namespace backend.DTOs.Accounts
{
    public class UserAccountAdminUpdateDTO
    {
        public required string username { get; set; }
        public required int roleId { get; set; }
        public required bool isActive { get; set; }
        public string? newPassword { get; set; }
    }
}
