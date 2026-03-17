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

    [MaxLength(1000)]
    public string? ImageUrl { get; set; }

    // Giá theo khung giờ (VND/giờ)
    public decimal MorningPrice { get; set; } = 20000;    // 6h - 11h
    public decimal AfternoonPrice { get; set; } = 50000;  // 11h - 17h
    public decimal EveningPrice { get; set; } = 80000;   // 17h - 23h

    [JsonIgnore]
    public ICollection<SubCourt> SubCourts { get; set; } = new List<SubCourt>();
}
