using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BadmintonBookingAPI.Data;
using BadmintonBookingAPI.DTOs;
using BadmintonBookingAPI.Models;

namespace BadmintonBookingAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UsersController : ControllerBase
{
    private readonly AppDbContext _context;

    public UsersController(AppDbContext context)
    {
        _context = context;
    }

    // POST: api/users/login
    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginDto dto)
    {
        var user = await _context.Users
            .FirstOrDefaultAsync(u => u.Phone == dto.Phone && u.Password == dto.Password);

        if (user == null)
            return Unauthorized(new { message = "Sai số điện thoại hoặc mật khẩu" });

        return Ok(new UserDto
        {
            Id = user.Id,
            Name = user.Name,
            Phone = user.Phone,
            Role = user.Role
        });
    }

    // POST: api/users/register
    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegisterDto dto)
    {
        var exists = await _context.Users.AnyAsync(u => u.Phone == dto.Phone);
        if (exists)
            return BadRequest(new { message = "Số điện thoại đã được đăng ký" });

        var user = new User
        {
            Name = dto.Name,
            Phone = dto.Phone,
            Password = dto.Password,
            Role = "player"
        };

        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        return Ok(new UserDto
        {
            Id = user.Id,
            Name = user.Name,
            Phone = user.Phone,
            Role = user.Role
        });
    }

    // GET: api/users/{id}
    [HttpGet("{id}")]
    public async Task<IActionResult> GetUser(int id)
    {
        var user = await _context.Users.FindAsync(id);
        if (user == null)
            return NotFound();

        return Ok(new UserDto
        {
            Id = user.Id,
            Name = user.Name,
            Phone = user.Phone,
            Role = user.Role
        });
    }

    // GET: api/users
    [HttpGet]
    public async Task<IActionResult> GetAllUsers()
    {
        var users = await _context.Users
            .Select(u => new UserDto
            {
                Id = u.Id,
                Name = u.Name,
                Phone = u.Phone,
                Role = u.Role
            })
            .ToListAsync();

        return Ok(users);
    }

    // PUT: api/users/{id}/role
    [HttpPut("{id}/role")]
    public async Task<IActionResult> UpdateRole(int id, [FromBody] UpdateRoleDto dto)
    {
        var user = await _context.Users.FindAsync(id);
        if (user == null)
            return NotFound(new { message = "Không tìm thấy người dùng" });

        user.Role = dto.Role;
        await _context.SaveChangesAsync();

        return Ok(new UserDto
        {
            Id = user.Id,
            Name = user.Name,
            Phone = user.Phone,
            Role = user.Role
        });
    }

    // DELETE: api/users/{id}
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteUser(int id)
    {
        var user = await _context.Users.FindAsync(id);
        if (user == null)
            return NotFound(new { message = "Không tìm thấy người dùng" });

        // Không cho xóa chính mình
        _context.Users.Remove(user);
        await _context.SaveChangesAsync();

        return Ok(new { message = "Đã xóa người dùng" });
    }
}
