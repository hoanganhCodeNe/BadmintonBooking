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

        // Kiểm tra đã có booking pending cho slot này chưa
        var existingPending = await _context.Bookings
            .AnyAsync(b => b.TimeSlotId == dto.TimeSlotId && b.Status == "pending");
        if (existingPending)
            return BadRequest(new { message = "Khung giờ đang chờ duyệt" });

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

        booking.Status = "approved";
        if (booking.TimeSlot != null)
            booking.TimeSlot.IsBooked = true;

        await _context.SaveChangesAsync();
        return Ok(new { message = "Đã duyệt đơn đặt sân" });
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
