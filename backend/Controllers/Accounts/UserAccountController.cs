using System;
using System.Collections.Generic;
using System.Linq;
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
        [Authorize]
        public async Task<ActionResult<IEnumerable<UserAccountDTO>>> GetUserAccounts()
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
    }
}
