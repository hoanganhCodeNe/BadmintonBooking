using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BadmintonBookingAPI.Data;
using BadmintonBookingAPI.DTOs;
using BadmintonBookingAPI.Models;

namespace BadmintonBookingAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class CourtsController : ControllerBase
{
    private readonly AppDbContext _context;

    public CourtsController(AppDbContext context)
    {
        _context = context;
    }

    // GET: api/courts
    [HttpGet]
    public async Task<IActionResult> GetAllCourts()
    {
        var courts = await _context.Courts.ToListAsync();
        return Ok(courts);
    }

    // GET: api/courts/{id}
    [HttpGet("{id}")]
    public async Task<IActionResult> GetCourt(int id)
    {
        var court = await _context.Courts.FindAsync(id);
        if (court == null)
            return NotFound();

        return Ok(court);
    }

    // POST: api/courts
    [HttpPost]
    public async Task<IActionResult> CreateCourt([FromBody] CourtDto dto)
    {
        var court = new Court
        {
            Name = dto.Name,
            Address = dto.Address,
            OwnerId = dto.OwnerId
        };

        _context.Courts.Add(court);
        await _context.SaveChangesAsync();

        return Ok(court);
    }

    // GET: api/courts/owner/{ownerId}
    [HttpGet("owner/{ownerId}")]
    public async Task<IActionResult> GetCourtsByOwner(int ownerId)
    {
        var courts = await _context.Courts
            .Where(c => c.OwnerId == ownerId)
            .ToListAsync();

        return Ok(courts);
    }

    // PUT: api/courts/{id}
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateCourt(int id, [FromBody] UpdateCourtDto dto)
    {
        var court = await _context.Courts.FindAsync(id);
        if (court == null)
            return NotFound(new { message = "Không tìm thấy sân" });

        court.Name = dto.Name;
        court.Address = dto.Address;
        await _context.SaveChangesAsync();

        return Ok(court);
    }

    // DELETE: api/courts/{id}
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteCourt(int id)
    {
        var court = await _context.Courts.FindAsync(id);
        if (court == null)
            return NotFound();

        _context.Courts.Remove(court);
        await _context.SaveChangesAsync();

        return Ok(new { message = "Đã xóa sân" });
    }
}
