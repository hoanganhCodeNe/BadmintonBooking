using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BadmintonBookingAPI.Data;
using BadmintonBookingAPI.Models;

namespace BadmintonBookingAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class TimeSlotsController : ControllerBase
{
    private readonly AppDbContext _context;

    public TimeSlotsController(AppDbContext context)
    {
        _context = context;
    }

    // GET: api/timeslots?subCourtId=1&date=2026-03-09
    [HttpGet]
    public async Task<IActionResult> GetTimeSlots([FromQuery] int subCourtId, [FromQuery] string date)
    {
        var slots = await _context.TimeSlots
            .Where(t => t.SubCourtId == subCourtId && t.Date == date)
            .OrderBy(t => t.StartTime)
            .ToListAsync();

        return Ok(slots);
    }

    // POST: api/timeslots/generate?subCourtId=1&date=2026-03-09
    [HttpPost("generate")]
    public async Task<IActionResult> GenerateTimeSlots([FromQuery] int subCourtId, [FromQuery] string date)
    {
        var subCourt = await _context.SubCourts.FindAsync(subCourtId);
        if (subCourt == null)
            return NotFound(new { message = "Không tìm thấy sân con" });

        // Kiểm tra đã có timeslot cho ngày này chưa
        var existing = await _context.TimeSlots
            .AnyAsync(t => t.SubCourtId == subCourtId && t.Date == date);

        if (existing)
            return Ok(new { message = "Timeslots đã tồn tại cho ngày này" });

        var slots = new List<TimeSlot>();
        for (int i = 6; i < 23; i++)
        {
            slots.Add(new TimeSlot
            {
                SubCourtId = subCourtId,
                Date = date,
                StartTime = $"{i}:00",
                EndTime = $"{i + 1}:00",
                IsBooked = false
            });
        }

        _context.TimeSlots.AddRange(slots);
        await _context.SaveChangesAsync();

        return Ok(slots);
    }
}
