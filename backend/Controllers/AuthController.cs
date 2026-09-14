using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Security.Cryptography;
using backend.Data;
using backend.DTOs.Login;
using backend.Models.Accounts;


namespace backend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IConfiguration _config;

        public AuthController(AppDbContext context, IConfiguration config)
        {
            _context = context;
            _config = config;
        }

        [HttpPost("login")]
        public async Task<ActionResult<LoginResponseDTO>> Login(LoginRequestDTO request)
        {            
            var userAccount = await _context.userAccounts
                .Include(ua => ua.role)
                .FirstOrDefaultAsync(ua => ua.username == request.username);

            if(userAccount == null || !userAccount.isActive)
                return Unauthorized("Invalid username or password.");
            
            var hasher = new PasswordHasher<UserAccount>();
            var result = hasher.VerifyHashedPassword(userAccount, userAccount.passwordHash, request.password);
            if (result == PasswordVerificationResult.Failed)
                return Unauthorized("Invalid username or password");
            
            var jwtKey = _config["Jwt:Key"]!;
            var jwtIssuer = _config["Jwt:Issuer"];
            var jwtAudience = _config["Jwt:Audience"];
            var expiryMinutes = int.Parse(_config["Jwt:ExpiryMinutes"]!);

            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, userAccount.userAccountId.ToString()),
                new Claim(ClaimTypes.Name, userAccount.username),
                new Claim(ClaimTypes.Role, userAccount.role!.roleName)
            };

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
            var expiresAt = DateTime.UtcNow.AddMinutes(expiryMinutes);

            var token = new JwtSecurityToken(
                issuer: jwtIssuer,
                audience: jwtAudience,
                claims: claims,
                expires: expiresAt,
                signingCredentials: creds
            );

            var rawRefreshToken = Convert.ToBase64String(RandomNumberGenerator.GetBytes(64));
            _context.refreshTokens.Add(new RefreshToken { userAccountId = userAccount.userAccountId, tokenHash = Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(rawRefreshToken))), expiresAt = DateTime.UtcNow.AddDays(int.Parse(_config["Jwt:RefreshExpiryDays"]!)) });
            await _context.SaveChangesAsync();
            Response.Cookies.Append("refreshToken", rawRefreshToken, new CookieOptions { HttpOnly = true, Secure = !HttpContext.Request.IsHttps ? false : true, SameSite = SameSiteMode.Lax, Path = "/api/auth" });

            return Ok(new LoginResponseDTO
            {
                token = new JwtSecurityTokenHandler().WriteToken(token),
                ExpiresAt = expiresAt,
                username = userAccount.username,
                roleName = userAccount.role.roleName
            });
        }

        [HttpPost("logout")]
        public async Task<IActionResult> Logout()
        {
            var raw = Request.Cookies["refreshToken"];
            if (raw != null) { var hash = Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(raw))); var token = await _context.refreshTokens.FirstOrDefaultAsync(rt => rt.tokenHash == hash); if (token != null) token.revokedAt = DateTime.UtcNow; await _context.SaveChangesAsync(); }
            Response.Cookies.Delete("refreshToken", new CookieOptions { Path = "/api/auth" });
            return NoContent();
        }

        [HttpPost("refresh")]
        public async Task<ActionResult<LoginResponseDTO>> Refresh()
        {
            var raw = Request.Cookies["refreshToken"];
            if (string.IsNullOrWhiteSpace(raw)) return Unauthorized();
            var hash = Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(raw)));
            var refreshToken = await _context.refreshTokens.Include(rt => rt.userAccount).ThenInclude(ua => ua!.role)
                .FirstOrDefaultAsync(rt => rt.tokenHash == hash && rt.revokedAt == null && rt.expiresAt > DateTime.UtcNow);
            if (refreshToken?.userAccount?.role == null || !refreshToken.userAccount.isActive) return Unauthorized();

            refreshToken.revokedAt = DateTime.UtcNow;
            var replacement = Convert.ToBase64String(RandomNumberGenerator.GetBytes(64));
            var refreshDays = int.Parse(_config["Jwt:RefreshExpiryDays"]!);
            _context.refreshTokens.Add(new RefreshToken { userAccountId = refreshToken.userAccountId, tokenHash = Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(replacement))), expiresAt = DateTime.UtcNow.AddDays(refreshDays) });
            await _context.SaveChangesAsync();
            Response.Cookies.Append("refreshToken", replacement, new CookieOptions { HttpOnly = true, Secure = Request.IsHttps, SameSite = SameSiteMode.Lax, Path = "/api/auth" });
            return Ok(CreateLoginResponse(refreshToken.userAccount));
        }

        private LoginResponseDTO CreateLoginResponse(UserAccount account)
        {
            var expiresAt = DateTime.UtcNow.AddMinutes(int.Parse(_config["Jwt:ExpiryMinutes"]!));
            var claims = new[] { new Claim(ClaimTypes.NameIdentifier, account.userAccountId.ToString()), new Claim(ClaimTypes.Name, account.username), new Claim(ClaimTypes.Role, account.role!.roleName) };
            var token = new JwtSecurityToken(_config["Jwt:Issuer"], _config["Jwt:Audience"], claims, expires: expiresAt, signingCredentials: new SigningCredentials(new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["Jwt:Key"]!)), SecurityAlgorithms.HmacSha256));
            return new LoginResponseDTO { token = new JwtSecurityTokenHandler().WriteToken(token), ExpiresAt = expiresAt, username = account.username, roleName = account.role.roleName };
        }
    }
}
