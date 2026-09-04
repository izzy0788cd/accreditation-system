using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
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

            return Ok(new LoginResponseDTO
            {
                token = new JwtSecurityTokenHandler().WriteToken(token),
                ExpiresAt = expiresAt,
                username = userAccount.username,
                roleName = userAccount.role.roleName
            });
        }
    }
}