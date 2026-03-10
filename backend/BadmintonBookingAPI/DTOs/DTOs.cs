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

public class CourtDto
{
    public string Name { get; set; } = string.Empty;
    public string Address { get; set; } = string.Empty;
    public int OwnerId { get; set; }
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
}
