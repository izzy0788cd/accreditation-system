namespace backend.DTOs.Accounts
{
    public class UserAccountAdminUpdateDTO
    {
        public required int roleId { get; set; }
        public required bool isActive { get; set; }
    }
}
