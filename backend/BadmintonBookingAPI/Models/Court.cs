using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace BadmintonBookingAPI.Models;

public class Court
{
    [Key]
    public int Id { get; set; }

    [Required]
    [MaxLength(200)]
    public string Name { get; set; } = string.Empty;

    [Required]
    [MaxLength(500)]
    public string Address { get; set; } = string.Empty;

    [Required]
    public int OwnerId { get; set; }

    [ForeignKey("OwnerId")]
    [JsonIgnore]
    public User? Owner { get; set; }

    [JsonIgnore]
    public ICollection<SubCourt> SubCourts { get; set; } = new List<SubCourt>();
}
