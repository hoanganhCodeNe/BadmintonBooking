using Microsoft.EntityFrameworkCore;
using BadmintonBookingAPI.Models;

namespace BadmintonBookingAPI.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<User> Users { get; set; }
    public DbSet<Court> Courts { get; set; }
    public DbSet<SubCourt> SubCourts { get; set; }
    public DbSet<TimeSlot> TimeSlots { get; set; }
    public DbSet<Booking> Bookings { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasIndex(u => u.Phone).IsUnique();
        });

        modelBuilder.Entity<Court>(entity =>
        {
            entity.HasOne(c => c.Owner)
                  .WithMany(u => u.Courts)
                  .HasForeignKey(c => c.OwnerId)
                  .OnDelete(DeleteBehavior.Restrict);
        });

        modelBuilder.Entity<SubCourt>(entity =>
        {
            entity.HasOne(sc => sc.Court)
                  .WithMany(c => c.SubCourts)
                  .HasForeignKey(sc => sc.CourtId)
                  .OnDelete(DeleteBehavior.Cascade);
        });

        modelBuilder.Entity<TimeSlot>(entity =>
        {
            entity.HasOne(t => t.SubCourt)
                  .WithMany(sc => sc.TimeSlots)
                  .HasForeignKey(t => t.SubCourtId)
                  .OnDelete(DeleteBehavior.Cascade);
        });

        modelBuilder.Entity<Booking>(entity =>
        {
            entity.HasOne(b => b.User)
                  .WithMany(u => u.Bookings)
                  .HasForeignKey(b => b.UserId)
                  .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(b => b.TimeSlot)
                  .WithMany(t => t.Bookings)
                  .HasForeignKey(b => b.TimeSlotId)
                  .OnDelete(DeleteBehavior.Restrict);
        });

        // Seed data
        modelBuilder.Entity<User>().HasData(
            new User { Id = 1, Name = "Admin", Phone = "0900000000", Password = "123456", Role = "admin" },
            new User { Id = 2, Name = "Nguyễn Văn A", Phone = "0901234567", Password = "123456", Role = "owner" },
            new User { Id = 3, Name = "Trần Thị B", Phone = "0907654321", Password = "123456", Role = "player" }
        );

        modelBuilder.Entity<Court>().HasData(
            new Court { Id = 1, Name = "Sân cầu lông Phú Cát", Address = "Khu CNC Hòa Lạc, Thạch Thất, Hà Nội", OwnerId = 2 },
            new Court { Id = 2, Name = "Sân cầu lông Hòa Lạc", Address = "Thôn 3, Thạch Hòa, Thạch Thất, Hà Nội", OwnerId = 2 }
        );

        modelBuilder.Entity<SubCourt>().HasData(
            new SubCourt { Id = 1, Name = "Sân 1", CourtId = 1 },
            new SubCourt { Id = 2, Name = "Sân 2", CourtId = 1 },
            new SubCourt { Id = 3, Name = "Sân 3", CourtId = 1 },
            new SubCourt { Id = 4, Name = "Sân 1", CourtId = 2 },
            new SubCourt { Id = 5, Name = "Sân 2", CourtId = 2 }
        );
    }
}
