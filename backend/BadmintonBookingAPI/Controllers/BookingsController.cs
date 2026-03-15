using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BadmintonBookingAPI.Data;
using BadmintonBookingAPI.DTOs;
using BadmintonBookingAPI.Models;

namespace BadmintonBookingAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class BookingsController : ControllerBase
{
    private readonly AppDbContext _context;

    public BookingsController(AppDbContext context)
    {
        _context = context;
    }

    // POST: api/bookings
    [HttpPost]
    public async Task<IActionResult> BookCourt([FromBody] BookingDto dto)
    {
        var slot = await _context.TimeSlots.FindAsync(dto.TimeSlotId);
        if (slot == null)
            return NotFound(new { message = "Không tìm thấy khung giờ" });

        if (slot.IsBooked)
            return BadRequest(new { message = "Khung giờ đã được đặt" });

        // Chặn booking trùng giờ thực sự cho cùng người dùng ở cùng sân con và ngày.
        // Lưu ý: booking liền kề (17:00-18:00 và 18:00-19:00) vẫn được phép.
        if (!TimeSpan.TryParse(slot.StartTime, out var newStart) ||
            !TimeSpan.TryParse(slot.EndTime, out var newEnd))
        {
            return BadRequest(new { message = "Khung giờ không hợp lệ" });
        }

        var activeBookings = await _context.Bookings
            .Include(b => b.TimeSlot)
            .Where(b => b.UserId == dto.UserId &&
                        (b.Status == "pending" || b.Status == "approved") &&
                        b.TimeSlot != null &&
                        b.TimeSlot.Date == slot.Date &&
                        b.TimeSlot.SubCourtId == slot.SubCourtId)
            .ToListAsync();

        var hasOverlap = activeBookings.Any(b =>
            TimeSpan.TryParse(b.TimeSlot!.StartTime, out var existedStart) &&
            TimeSpan.TryParse(b.TimeSlot.EndTime, out var existedEnd) &&
            newStart < existedEnd && existedStart < newEnd);

        if (hasOverlap)
            return BadRequest(new { message = "Bạn đã có lịch trùng giờ ở sân này" });

        var booking = new Booking
        {
            UserId = dto.UserId,
            TimeSlotId = dto.TimeSlotId,
            Status = "pending",
            CreatedAt = DateTime.Now
        };

        _context.Bookings.Add(booking);
        await _context.SaveChangesAsync();

        return Ok(new { message = "Đã gửi yêu cầu đặt sân, chờ duyệt", bookingId = booking.Id });
    }

    // PUT: api/bookings/{id}/approve
    [HttpPut("{id}/approve")]
    public async Task<IActionResult> ApproveBooking(int id)
    {
        var booking = await _context.Bookings
            .Include(b => b.TimeSlot)
            .FirstOrDefaultAsync(b => b.Id == id);

        if (booking == null)
            return NotFound(new { message = "Không tìm thấy booking" });

        if (booking.Status != "pending")
            return BadRequest(new { message = "Chỉ duyệt được đơn đang chờ" });

        var alreadyApproved = await _context.Bookings
            .AnyAsync(b => b.TimeSlotId == booking.TimeSlotId && b.Status == "approved");
        if (alreadyApproved)
            return BadRequest(new { message = "Khung giờ này đã được duyệt cho người khác" });

        booking.Status = "approved";
        if (booking.TimeSlot != null)
            booking.TimeSlot.IsBooked = true;

        // Khi đã duyệt 1 người cho khung giờ này, tự động từ chối các yêu cầu pending còn lại.
        var otherPending = await _context.Bookings
            .Where(b => b.TimeSlotId == booking.TimeSlotId && b.Status == "pending" && b.Id != booking.Id)
            .ToListAsync();

        foreach (var item in otherPending)
        {
            item.Status = "rejected";
        }

        await _context.SaveChangesAsync();
        return Ok(new
        {
            message = "Đã duyệt đơn đặt sân",
            rejectedCount = otherPending.Count
        });
    }

    // PUT: api/bookings/{id}/reject
    [HttpPut("{id}/reject")]
    public async Task<IActionResult> RejectBooking(int id)
    {
        var booking = await _context.Bookings
            .FirstOrDefaultAsync(b => b.Id == id);

        if (booking == null)
            return NotFound(new { message = "Không tìm thấy booking" });

        if (booking.Status != "pending")
            return BadRequest(new { message = "Chỉ từ chối được đơn đang chờ" });

        booking.Status = "rejected";
        await _context.SaveChangesAsync();

        return Ok(new { message = "Đã từ chối đơn đặt sân" });
    }

    // GET: api/bookings/history/{userId}
    [HttpGet("history/{userId}")]
    public async Task<IActionResult> GetBookingHistory(int userId)
    {
        var bookings = await _context.Bookings
            .Where(b => b.UserId == userId)
            .Include(b => b.TimeSlot!)
            .ThenInclude(t => t.SubCourt!)
            .ThenInclude(sc => sc.Court!)
            .OrderByDescending(b => b.CreatedAt)
            .Select(b => new BookingHistoryDto
            {
                Id = b.Id,
                CourtName = b.TimeSlot!.SubCourt!.Court!.Name,
                SubCourtName = b.TimeSlot.SubCourt!.Name,
                Date = b.TimeSlot.Date,
                StartTime = b.TimeSlot.StartTime,
                EndTime = b.TimeSlot.EndTime,
                Status = b.Status,
                RejectReason = b.Status == "rejected"
                    ? (b.TimeSlot.IsBooked
                        ? "Khung giờ đã được duyệt cho người chơi khác"
                        : "Chủ sân đã từ chối yêu cầu của bạn")
                    : string.Empty,
                CreatedAt = b.CreatedAt.ToString("yyyy-MM-dd HH:mm")
            })
            .ToListAsync();

        return Ok(bookings);
    }

    // GET: api/bookings/owner/{ownerId}
    [HttpGet("owner/{ownerId}")]
    public async Task<IActionResult> GetOwnerBookings(int ownerId)
    {
        var bookings = await _context.Bookings
            .Include(b => b.User!)
            .Include(b => b.TimeSlot!)
            .ThenInclude(t => t.SubCourt!)
            .ThenInclude(sc => sc.Court!)
            .Where(b => b.TimeSlot!.SubCourt!.Court!.OwnerId == ownerId)
            .OrderByDescending(b => b.CreatedAt)
            .Select(b => new OwnerBookingDto
            {
                Id = b.Id,
                PlayerName = b.User!.Name,
                PlayerPhone = b.User.Phone,
                CourtName = b.TimeSlot!.SubCourt!.Court!.Name,
                SubCourtName = b.TimeSlot.SubCourt!.Name,
                Date = b.TimeSlot.Date,
                StartTime = b.TimeSlot.StartTime,
                EndTime = b.TimeSlot.EndTime,
                Status = b.Status,
                CreatedAt = b.CreatedAt.ToString("yyyy-MM-dd HH:mm")
            })
            .ToListAsync();

        return Ok(bookings);
    }

    // PUT: api/bookings/{id}/cancel
    [HttpPut("{id}/cancel")]
    public async Task<IActionResult> CancelBooking(int id)
    {
        var booking = await _context.Bookings
            .Include(b => b.TimeSlot)
            .FirstOrDefaultAsync(b => b.Id == id);

        if (booking == null)
            return NotFound(new { message = "Không tìm thấy booking" });

        if (booking.Status == "cancelled")
            return BadRequest(new { message = "Đơn đã bị hủy rồi" });

        // Nếu đã duyệt thì mở lại timeslot
        if (booking.Status == "approved" && booking.TimeSlot != null)
            booking.TimeSlot.IsBooked = false;

        booking.Status = "cancelled";
        await _context.SaveChangesAsync();

        return Ok(new { message = "Đã hủy đặt sân" });
    }
}
