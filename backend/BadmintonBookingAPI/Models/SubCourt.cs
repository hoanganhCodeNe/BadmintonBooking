using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace BadmintonBookingAPI.Models;

public class SubCourt
{
    [Key]
    public int Id { get; set; }

    [Required]
    [MaxLength(100)]
    public string Name { get; set; } = string.Empty;

    [Required]
    public int CourtId { get; set; }

    [ForeignKey("CourtId")]
    [JsonIgnore]
    public Court? Court { get; set; }

    [JsonIgnore]
    public ICollection<TimeSlot> TimeSlots { get; set; } = new List<TimeSlot>();
}
