namespace BadmintonBookingAPI.DTOs;

public class LoginDto
{
    public string Phone { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
}

public class RegisterDto
{
    public string Name { get; set; } = string.Empty;
    public string Phone { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
}

public class UserDto
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Phone { get; set; } = string.Empty;
    public string Role { get; set; } = string.Empty;
}

public class BookingDto
{
    public int UserId { get; set; }
    public int TimeSlotId { get; set; }
}

public class UpdateRoleDto
{
    public string Role { get; set; } = string.Empty;
}

public class UpdateProfileDto
{
    public string Name { get; set; } = string.Empty;
    public string Phone { get; set; } = string.Empty;
}

public class ChangePasswordDto
{
    public string CurrentPassword { get; set; } = string.Empty;
    public string NewPassword { get; set; } = string.Empty;
}

public class CourtDto
{
    public string Name { get; set; } = string.Empty;
    public string Address { get; set; } = string.Empty;
    public int OwnerId { get; set; }
    public string? ImageUrl { get; set; }
    public List<string>? ImageUrls { get; set; }
    public decimal MorningPrice { get; set; } = 20000;
    public decimal AfternoonPrice { get; set; } = 50000;
    public decimal EveningPrice { get; set; } = 80000;
}

public class CourtListDto
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Address { get; set; } = string.Empty;
    public int OwnerId { get; set; }
    public int SubCourtCount { get; set; }
    public string? ImageUrl { get; set; }
    public List<string> ImageUrls { get; set; } = new();
    public decimal MorningPrice { get; set; }
    public decimal AfternoonPrice { get; set; }
    public decimal EveningPrice { get; set; }
}

public class SubCourtDto
{
    public string Name { get; set; } = string.Empty;
    public int CourtId { get; set; }
}

public class BookingHistoryDto
{
    public int Id { get; set; }
    public string CourtName { get; set; } = string.Empty;
    public string SubCourtName { get; set; } = string.Empty;
    public string Date { get; set; } = string.Empty;
    public string StartTime { get; set; } = string.Empty;
    public string EndTime { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public string RejectReason { get; set; } = string.Empty;
    public string CreatedAt { get; set; } = string.Empty;
}

public class OwnerBookingDto
{
    public int Id { get; set; }
    public string PlayerName { get; set; } = string.Empty;
    public string PlayerPhone { get; set; } = string.Empty;
    public string CourtName { get; set; } = string.Empty;
    public string SubCourtName { get; set; } = string.Empty;
    public string Date { get; set; } = string.Empty;
    public string StartTime { get; set; } = string.Empty;
    public string EndTime { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public string CreatedAt { get; set; } = string.Empty;
}

public class UpdateCourtDto
{
    public string Name { get; set; } = string.Empty;
    public string Address { get; set; } = string.Empty;
    public string? ImageUrl { get; set; }
    public List<string>? ImageUrls { get; set; }
    public decimal MorningPrice { get; set; } = 20000;
    public decimal AfternoonPrice { get; set; } = 50000;
    public decimal EveningPrice { get; set; } = 80000;
}
