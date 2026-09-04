using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using backend.Data;
using backend.DTOs.Accounts;
using backend.Models.Accounts;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers.Accounts
{
    [ApiController]
    [Route("api/users")]
    public class UsersController : ControllerBase
    {
        private readonly AppDbContext _context;

        public UsersController(AppDbContext context) => _context = context;

        [HttpGet("me")]
        [Authorize]
        public async Task<ActionResult<UserResponseDTO>> GetOwnProfile()
        {
            var userAccountId = int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

            var user = await _context
                .users.Include(u => u.userAccount)
                .Include(u => u.organization)
                .Where(u => u.userAccountId == userAccountId)
                .Select(u => new UserResponseDTO
                {
                    userId = u.userId,
                    userAccountId = u.userAccountId,
                    username = u.userAccount!.username,
                    firstName = u.firstName,
                    lastName = u.lastName,
                    organizationId = u.organizationId,
                    organizationName = u.organization!.organizationName,
                    position = u.position,
                    email = u.email,
                    phone = u.phone,
                    mobile = u.mobile,
                    comments = u.comments,
                })
                .FirstOrDefaultAsync();

            if (user == null)
            {
                return NotFound("User profile not found.");
            }

            return Ok(user);
        }

        [HttpGet("{userId}")]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<UserResponseDTO>> GetUserById(int userId)
        {
            var userAccount = await _context
                .userAccounts.Include(ua => ua.user)
                    .ThenInclude(u => u.organization)
                .Where(ua => ua.user!.userId == userId)
                .Select(ua => new UserResponseDTO
                {
                    userId = ua.user!.userId,
                    userAccountId = ua.userAccountId,
                    username = ua.username,
                    firstName = ua.user.firstName,
                    lastName = ua.user.lastName,
                    organizationId = ua.user.organizationId,
                    organizationName = ua.user.organization!.organizationName,
                    position = ua.user.position,
                    email = ua.user.email,
                    phone = ua.user.phone,
                    mobile = ua.user.mobile,
                    comments = ua.user.comments,
                })
                .FirstOrDefaultAsync();

            if (userAccount == null)
            {
                return NotFound("User not found.");
            }

            return Ok(userAccount);
        }

        [HttpGet]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<List<UserResponseDTO>>> GetAll()
        {
            var users = await _context
                .users.Include(u => u.organization)
                .Include(u => u.userAccount)
                .Select(u => new UserResponseDTO
                {
                    userId = u.userId,
                    userAccountId = u.userAccountId,
                    username = u.userAccount!.username,
                    firstName = u.firstName,
                    lastName = u.lastName,
                    organizationId = u.organizationId,
                    organizationName = u.organization!.organizationName,
                    position = u.position,
                    email = u.email,
                    phone = u.phone,
                    mobile = u.mobile,
                    comments = u.comments,
                })
                .ToListAsync();

            return Ok(users);
        }

        [HttpPost("admin-create")]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<UserSummaryDTO>> AdminCreate(UserAdminCreateDTO dto)
        {
            var accountExists = await _context.userAccounts.AnyAsync(ua =>
                ua.userAccountId == dto.userAccountId
            );
            if (!accountExists)
                return BadRequest("userAccountId does not exist.");

            var alreadyHasProfile = await _context.users.AnyAsync(u =>
                u.userAccountId == dto.userAccountId
            );
            if (alreadyHasProfile)
                return BadRequest("User already has a profile.");

            var user = new User
            {
                userAccountId = dto.userAccountId,
                firstName = dto.firstName,
                lastName = dto.lastName,
                organizationId = dto.organizationId,
                position = dto.position,
                email = dto.email,
                phone = dto.phone,
                mobile = dto.mobile,
                comments = dto.comments,
            };

            _context.users.Add(user);
            await _context.SaveChangesAsync();

            return Ok(ToSummaryDTO(user));
        }

        [HttpPut("{userId}")]
        [Authorize(Roles = "Admin")]
        public async Task<ActionResult<UserSummaryDTO>> AdminUpdate(int userId, UserUpdateDTO dto)
        {
            var user = await _context.users.FindAsync(userId);
            if (user == null)
                return NotFound("User not found.");

            ApplyUpdate(user, dto);
            await _context.SaveChangesAsync();

            return Ok(ToSummaryDTO(user));
        }

        [HttpPut("me")]
        [Authorize]
        public async Task<ActionResult<UserSummaryDTO>> UpdateOwnProfile(UserUpdateDTO dto)
        {
            var userAccountId = int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
            var user = await _context.users.FirstOrDefaultAsync(u =>
                u.userAccountId == userAccountId
            );
            if (user == null)
                return NotFound("User profile not found.");

            ApplyUpdate(user, dto);
            await _context.SaveChangesAsync();

            return Ok(ToSummaryDTO(user));
        }

        [HttpPost]
        [Authorize]
        public async Task<IActionResult> CompleteProfile([FromBody] CompleteProfileDTO dto)
        {
            var userAccountId = int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

            var alreadyExists = await _context.users.AnyAsync(u =>
                u.userAccountId == userAccountId
            );
            if (alreadyExists)
                return BadRequest("Profile already completed.");

            var user = new User
            {
                userAccountId = userAccountId,
                firstName = dto.firstName,
                lastName = dto.lastName,
                organizationId = dto.organizationId,
                position = dto.position,
                email = dto.email,
                phone = dto.phone,
                mobile = dto.mobile,
                comments = dto.comments,
            };

            _context.users.Add(user);
            await _context.SaveChangesAsync();

            return Ok(ToSummaryDTO(user));
        }

        private static void ApplyUpdate(User user, UserUpdateDTO dto)
        {
            if (dto.firstName != null)
                user.firstName = dto.firstName;
            if (dto.lastName != null)
                user.lastName = dto.lastName;
            if (dto.organizationId.HasValue)
                user.organizationId = dto.organizationId.Value;
            if (dto.position != null)
                user.position = dto.position;
            if (dto.email != null)
                user.email = dto.email;
            if (dto.phone != null)
                user.phone = dto.phone;
            if (dto.mobile != null)
                user.mobile = dto.mobile;
            if (dto.comments != null)
                user.comments = dto.comments;
        }

        private static UserSummaryDTO ToSummaryDTO(User user) =>
            new()
            {
                userId = user.userId,
                userAccountId = user.userAccountId,
                firstName = user.firstName,
                lastName = user.lastName,
                organizationId = user.organizationId,
                position = user.position,
                email = user.email,
                phone = user.phone,
                mobile = user.mobile,
                comments = user.comments,
            };
    }
}
