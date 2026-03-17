using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BadmintonBookingAPI.Data;
using BadmintonBookingAPI.DTOs;
using BadmintonBookingAPI.Models;
using System.Text.Json;

namespace BadmintonBookingAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class CourtsController : ControllerBase
{
    private readonly AppDbContext _context;
    private readonly IWebHostEnvironment _environment;

    public CourtsController(AppDbContext context, IWebHostEnvironment environment)
    {
        _context = context;
        _environment = environment;
    }

    private static bool HasInvalidPrices(decimal morningPrice, decimal afternoonPrice, decimal eveningPrice)
    {
        return morningPrice < 0 || afternoonPrice < 0 || eveningPrice < 0;
    }

    private static List<string> ParseImageUrls(string? rawImageData)
    {
        if (string.IsNullOrWhiteSpace(rawImageData))
            return new List<string>();

        var trimmed = rawImageData.Trim();
        if (!trimmed.StartsWith("["))
            return new List<string> { trimmed };

        try
        {
            return JsonSerializer.Deserialize<List<string>>(trimmed) ?? new List<string>();
        }
        catch
        {
            return new List<string>();
        }
    }

    private static string? SerializeImageUrls(List<string>? imageUrls, string? fallbackImageUrl = null)
    {
        var cleaned = (imageUrls ?? new List<string>())
            .Where(url => !string.IsNullOrWhiteSpace(url))
            .Take(5)
            .ToList();

        if (cleaned.Count > 0)
            return JsonSerializer.Serialize(cleaned);

        return string.IsNullOrWhiteSpace(fallbackImageUrl)
            ? null
            : JsonSerializer.Serialize(new List<string> { fallbackImageUrl });
    }

    private string NormalizeImageUrl(string? rawUrl)
    {
        if (string.IsNullOrWhiteSpace(rawUrl))
            return string.Empty;

        var value = rawUrl.Trim();

        if (value.StartsWith("/"))
            return $"{Request.Scheme}://{Request.Host}{value}";

        if (Uri.TryCreate(value, UriKind.Absolute, out var uri))
            return $"{Request.Scheme}://{Request.Host}{uri.AbsolutePath}";

        return value;
    }

    private CourtListDto MapCourtToDto(Court c)
    {
        var imageUrls = ParseImageUrls(c.ImageUrl)
            .Select(NormalizeImageUrl)
            .Where(url => !string.IsNullOrWhiteSpace(url))
            .ToList();

        return new CourtListDto
        {
            Id = c.Id,
            Name = c.Name,
            Address = c.Address,
            OwnerId = c.OwnerId,
            SubCourtCount = c.SubCourts.Count,
            ImageUrl = imageUrls.FirstOrDefault(),
            ImageUrls = imageUrls,
            MorningPrice = c.MorningPrice,
            AfternoonPrice = c.AfternoonPrice,
            EveningPrice = c.EveningPrice
        };
    }

    // GET: api/courts
    [HttpGet]
    public async Task<IActionResult> GetAllCourts()
    {
        var courts = await _context.Courts
            .Include(c => c.SubCourts)
            .ToListAsync();

        return Ok(courts.Select(MapCourtToDto));
    }

    // GET: api/courts/{id}
    [HttpGet("{id}")]
    public async Task<IActionResult> GetCourt(int id)
    {
        var court = await _context.Courts
            .Include(c => c.SubCourts)
            .FirstOrDefaultAsync(c => c.Id == id);
        if (court == null)
            return NotFound();

        return Ok(MapCourtToDto(court));
    }

    // POST: api/courts
    [HttpPost]
    public async Task<IActionResult> CreateCourt([FromBody] CourtDto dto)
    {
        if (HasInvalidPrices(dto.MorningPrice, dto.AfternoonPrice, dto.EveningPrice))
            return BadRequest(new { message = "Giá tiền không được âm" });

        var court = new Court
        {
            Name = dto.Name,
            Address = dto.Address,
            OwnerId = dto.OwnerId,
            ImageUrl = SerializeImageUrls(dto.ImageUrls, dto.ImageUrl),
            MorningPrice = dto.MorningPrice,
            AfternoonPrice = dto.AfternoonPrice,
            EveningPrice = dto.EveningPrice
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
            .Include(c => c.SubCourts)
            .ToListAsync();

        return Ok(courts.Select(MapCourtToDto));
    }

    // PUT: api/courts/{id}
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateCourt(int id, [FromBody] UpdateCourtDto dto)
    {
        var court = await _context.Courts.FindAsync(id);
        if (court == null)
            return NotFound(new { message = "Không tìm thấy sân" });

        if (HasInvalidPrices(dto.MorningPrice, dto.AfternoonPrice, dto.EveningPrice))
            return BadRequest(new { message = "Giá tiền không được âm" });

        court.Name = dto.Name;
        court.Address = dto.Address;
        court.ImageUrl = SerializeImageUrls(dto.ImageUrls, dto.ImageUrl);
        court.MorningPrice = dto.MorningPrice;
        court.AfternoonPrice = dto.AfternoonPrice;
        court.EveningPrice = dto.EveningPrice;
        await _context.SaveChangesAsync();

        return Ok(court);
    }

    // POST: api/courts/{id}/images
    [HttpPost("{id}/images")]
    public async Task<IActionResult> UploadCourtImages(int id, [FromForm] List<IFormFile> images)
    {
        var court = await _context.Courts.FindAsync(id);
        if (court == null)
            return NotFound(new { message = "Không tìm thấy sân" });

        if (images == null || images.Count == 0)
            return BadRequest(new { message = "Vui lòng chọn ít nhất 1 ảnh" });

        if (images.Count > 5)
            return BadRequest(new { message = "Chỉ được tải lên tối đa 5 ảnh" });

        var uploadDirectory = Path.Combine(_environment.ContentRootPath, "wwwroot", "uploads", "courts", id.ToString());
        Directory.CreateDirectory(uploadDirectory);

        var uploadedUrls = new List<string>();
        foreach (var image in images.Where(file => file.Length > 0).Take(5))
        {
            var extension = Path.GetExtension(image.FileName);
            var safeFileName = $"{Guid.NewGuid():N}{extension}";
            var savePath = Path.Combine(uploadDirectory, safeFileName);

            await using var stream = new FileStream(savePath, FileMode.Create);
            await image.CopyToAsync(stream);

            var fileUrl = $"/uploads/courts/{id}/{safeFileName}";
            uploadedUrls.Add(fileUrl);
        }

        return Ok(uploadedUrls);
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
