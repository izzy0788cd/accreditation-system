using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace backend.Models.Accounts;

public class RefreshToken
{
    [Key] public int refreshTokenId { get; set; }
    public int userAccountId { get; set; }
    [ForeignKey(nameof(userAccountId))] public UserAccount? userAccount { get; set; }
    public required string tokenHash { get; set; }
    public DateTime expiresAt { get; set; }
    public DateTime? revokedAt { get; set; }
}
