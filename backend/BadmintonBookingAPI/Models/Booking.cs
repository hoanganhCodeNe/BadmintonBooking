using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace BadmintonBookingAPI.Models;

public class Booking
{
    [Key]
    public int Id { get; set; }

    [Required]
    public int UserId { get; set; }

    [Required]
    public int TimeSlotId { get; set; }

    [Required]
    public string Status { get; set; } = "pending"; // pending, approved, rejected, cancelled

    public DateTime CreatedAt { get; set; } = DateTime.Now;

    [ForeignKey("UserId")]
    [JsonIgnore]
    public User? User { get; set; }

    [ForeignKey("TimeSlotId")]
    [JsonIgnore]
    public TimeSlot? TimeSlot { get; set; }
}
