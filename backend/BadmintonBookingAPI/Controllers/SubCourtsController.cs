using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BadmintonBookingAPI.Data;
using BadmintonBookingAPI.DTOs;
using BadmintonBookingAPI.Models;

namespace BadmintonBookingAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class SubCourtsController : ControllerBase
{
    private readonly AppDbContext _context;

    public SubCourtsController(AppDbContext context)
    {
        _context = context;
    }

    // GET: api/subcourts?courtId=1
    [HttpGet]
    public async Task<IActionResult> GetSubCourts([FromQuery] int courtId)
    {
        var subCourts = await _context.SubCourts
            .Where(sc => sc.CourtId == courtId)
            .ToListAsync();

        return Ok(subCourts);
    }

    // POST: api/subcourts
    [HttpPost]
    public async Task<IActionResult> CreateSubCourt([FromBody] SubCourtDto dto)
    {
        var court = await _context.Courts.FindAsync(dto.CourtId);
        if (court == null)
            return NotFound(new { message = "Không tìm thấy sân" });

        var subCourt = new SubCourt
        {
            Name = dto.Name,
            CourtId = dto.CourtId
        };

        _context.SubCourts.Add(subCourt);
        await _context.SaveChangesAsync();

        return Ok(subCourt);
    }

    // DELETE: api/subcourts/{id}
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteSubCourt(int id)
    {
        var subCourt = await _context.SubCourts.FindAsync(id);
        if (subCourt == null)
            return NotFound();

        _context.SubCourts.Remove(subCourt);
        await _context.SaveChangesAsync();

        return Ok(new { message = "Đã xóa sân con" });
    }
}
