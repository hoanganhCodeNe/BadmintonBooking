using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace BadmintonBookingAPI.Migrations
{
    /// <inheritdoc />
    public partial class AddCourtImageAndPrices : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<decimal>(
                name: "AfternoonPrice",
                table: "Courts",
                type: "decimal(18,2)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.AddColumn<decimal>(
                name: "EveningPrice",
                table: "Courts",
                type: "decimal(18,2)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.AddColumn<string>(
                name: "ImageUrl",
                table: "Courts",
                type: "nvarchar(1000)",
                maxLength: 1000,
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "MorningPrice",
                table: "Courts",
                type: "decimal(18,2)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.UpdateData(
                table: "Courts",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "AfternoonPrice", "EveningPrice", "ImageUrl", "MorningPrice" },
                values: new object[] { 50000m, 80000m, null, 20000m });

            migrationBuilder.UpdateData(
                table: "Courts",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "AfternoonPrice", "EveningPrice", "ImageUrl", "MorningPrice" },
                values: new object[] { 50000m, 80000m, null, 20000m });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "AfternoonPrice",
                table: "Courts");

            migrationBuilder.DropColumn(
                name: "EveningPrice",
                table: "Courts");

            migrationBuilder.DropColumn(
                name: "ImageUrl",
                table: "Courts");

            migrationBuilder.DropColumn(
                name: "MorningPrice",
                table: "Courts");
        }
    }
}
