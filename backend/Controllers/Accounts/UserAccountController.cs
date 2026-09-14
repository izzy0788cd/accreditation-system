using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using backend.Data;
using backend.DTOs.Accounts;
using backend.Models.Accounts;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers.Accounts
{
    [ApiController]
    [Route("api/userAccounts")]
    public class UserAccountController : ControllerBase
    {
        private readonly AppDbContext _context;

        public UserAccountController(AppDbContext context) => _context = context;

        [HttpGet]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<IEnumerable<UserAccountResponseDTO>>> GetUserAccounts()
        {
            var userAccounts = await _context
                .userAccounts.Select(ua => new UserAccountResponseDTO
                {
                    userAccountId = ua.userAccountId,
                    username = ua.username,
                    roleName = ua.role!.roleName,
                    isActive = ua.isActive,
                    dateCreated = ua.dateCreated.ToDateTime(TimeOnly.MinValue),
                })
                .ToListAsync();

            return Ok(userAccounts);
        }

        [HttpPost]
        [Authorize]
        public async Task<IActionResult> CreateUserAccount([FromBody] CreateUserAccountDTO dto)
        {
            if (await _context.userAccounts.AnyAsync(account => account.username == dto.username))
                return BadRequest("That username is already in use.");

            var anyAdminsExist = await _context.userAccounts.AnyAsync(ua =>
                ua.role!.roleName == "Admin"
            );

            if (anyAdminsExist)
            {
                var isAuthenticatedAdmin =
                    User.Identity?.IsAuthenticated == true && User.IsInRole("Admin");
                if (!isAuthenticatedAdmin)
                    return Forbid();
            }

            var userAccount = new UserAccount
            {
                username = dto.username,
                roleId = dto.roleId,
                passwordHash = "",
                isActive = true,
                dateCreated = DateOnly.FromDateTime(DateTime.UtcNow),
            };

            var hasher = new PasswordHasher<UserAccount>();
            userAccount.passwordHash = hasher.HashPassword(userAccount, dto.temporaryPassword);

            _context.userAccounts.Add(userAccount);
            await _context.SaveChangesAsync();

            return Ok(
                new UserAccountResponseDTO
                {
                    userAccountId = userAccount.userAccountId,
                    username = userAccount.username,
                    roleName =
                        (await _context.roles.FindAsync(userAccount.roleId))?.roleName ?? "Unknown",
                    isActive = userAccount.isActive,
                    dateCreated = userAccount.dateCreated.ToDateTime(TimeOnly.MinValue),
                }
            );
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<UserAccountResponseDTO>> UpdateUserAccount(
            int id,
            UserAccountAdminUpdateDTO dto
        )
        {
            var userAccount = await _context.userAccounts.FindAsync(id);
            if (userAccount == null)
                return NotFound("User account not found.");

            var role = await _context.roles.FindAsync(dto.roleId);
            if (role == null)
                return BadRequest("roleId does not exist.");

            var username = dto.username.Trim();
            if (string.IsNullOrWhiteSpace(username))
                return BadRequest("Username is required.");
            if (
                await _context.userAccounts.AnyAsync(account =>
                    account.username == username && account.userAccountId != id
                )
            )
                return BadRequest("That username is already in use.");

            var currentUserAccountId = int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
            if (userAccount.userAccountId == currentUserAccountId && !dto.isActive)
                return BadRequest("You cannot deactivate your own account.");
            if (userAccount.userAccountId == currentUserAccountId && role.roleName != "Admin")
                return BadRequest("You cannot remove your own Admin role.");

            userAccount.roleId = dto.roleId;
            userAccount.username = username;
            userAccount.isActive = dto.isActive;
            if (!string.IsNullOrWhiteSpace(dto.newPassword))
            {
                if (dto.newPassword.Length < 8)
                    return BadRequest("The new password must be at least 8 characters.");

                var hasher = new PasswordHasher<UserAccount>();
                userAccount.passwordHash = hasher.HashPassword(userAccount, dto.newPassword);
                var activeSessions = await _context
                    .refreshTokens.Where(token => token.userAccountId == userAccount.userAccountId)
                    .ToListAsync();
                _context.refreshTokens.RemoveRange(activeSessions);
            }
            await _context.SaveChangesAsync();

            return Ok(
                new UserAccountResponseDTO
                {
                    userAccountId = userAccount.userAccountId,
                    username = userAccount.username,
                    roleName = role.roleName,
                    isActive = userAccount.isActive,
                    dateCreated = userAccount.dateCreated.ToDateTime(TimeOnly.MinValue),
                }
            );
        }
    }
}
