using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace BadmintonBookingAPI.Models;

public class TimeSlot
{
    [Key]
    public int Id { get; set; }

    [Required]
    public int SubCourtId { get; set; }

    [Required]
    [MaxLength(10)]
    public string Date { get; set; } = string.Empty;

    [Required]
    [MaxLength(10)]
    public string StartTime { get; set; } = string.Empty;

    [Required]
    [MaxLength(10)]
    public string EndTime { get; set; } = string.Empty;

    public bool IsBooked { get; set; } = false;

    [ForeignKey("SubCourtId")]
    [JsonIgnore]
    public SubCourt? SubCourt { get; set; }

    [JsonIgnore]
    public ICollection<Booking> Bookings { get; set; } = new List<Booking>();
}
