using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using backend.Models.Framework;
using backend.Models.Location;
using backend.Models.Facilities;
using backend.Models.Accounts;
using backend.Models.Scoring;
using backend.Models.FaciltitySurvey;

namespace backend.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions options) : base(options)
        {
            
        }
        
        //db sets for framework
        public DbSet<Function> functions { get; set; }
        public DbSet<Component> components { get; set; }
        public DbSet<Standard> standards { get; set; }
        public DbSet<Criterion> criteria { get; set; }
        public DbSet<Compliance> compliances { get; set; }
        public DbSet<Evidence> evidence { get; set; }

        //db sets for location
        public DbSet<Region> regions { get; set; }
        public DbSet<Province> provinces { get; set; }
        public DbSet<District> districts { get; set; }

        //db sets for facility
        public DbSet<Level> levels { get; set; }
        public DbSet<Category> categories { get; set; }
        public DbSet<Organization> organizations { get; set; }
        public DbSet<CreditationStatus> creditationStatuses { get; set; }
        public DbSet<Facility> facilities { get; set; }

        //db sets for users
        public DbSet<Role> roles { get; set; }
        public DbSet<UserAccount> userAccounts { get; set; }
        public DbSet<User> users { get; set; }

        //db sets for scores & risk rating
        public DbSet<Score> scores { get; set; }
        public DbSet<RiskRating> riskRatings { get; set; }

        //db sets for facility survey(s)
        public DbSet<SurveyorCertStatus> surveyorCertStatuses { get; set; }
        public DbSet<Specialization> specializations { get; set; }
        public DbSet<Surveyors> surveyors { get; set; }
        public DbSet<SurveyType> surveyTypes { get; set; }
        public DbSet<Survey> surveys { get; set; }

        //database relationships between the tables created...

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            //Framework relationships
            modelBuilder.Entity<Component>().HasKey(c => c.componentId);
            modelBuilder.Entity<Component>()
                .HasIndex(c => c.componentNumber)
                .IsUnique();
            
            modelBuilder.Entity<Function>().HasKey(f => f.functionId);
            modelBuilder.Entity<Function>()
                .HasIndex(f => f.functionNumber)
                .IsUnique();

            modelBuilder.Entity<Standard>().HasKey(s => s.standardId);
            modelBuilder.Entity<Standard>()
                .HasIndex(s => s.standardNumber)
                .IsUnique();
            
            modelBuilder.Entity<Standard>()
                .HasOne(s => s.component)
                .WithMany(c => c.standards)
                .HasForeignKey(s => s.componentId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Standard>()
                .HasOne(s => s.function)
                .WithMany(f => f.standards)
                .HasForeignKey(s => s.functionId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Criterion>().HasKey(cr => cr.criterionId);
            modelBuilder.Entity<Criterion>()
                .HasIndex(cr => new { cr.standardId, cr.criterionNumber})
                .IsUnique();

            modelBuilder.Entity<Criterion>()
                .Property(cr => cr.isApplicable)
                .HasDefaultValue(true);
            
            modelBuilder.Entity<Criterion>()
                .HasOne(cr => cr.standard)
                .WithMany(s => s.criteria)
                .HasForeignKey(cr => cr.standardId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Compliance>().HasKey(co => co.complianceId);
            modelBuilder.Entity<Compliance>()
                .HasIndex(co => new { co.criterionId, co.complianceNumber})
                .IsUnique();
                
            modelBuilder.Entity<Compliance>()
                .Property(co => co.isApplicable)
                .HasDefaultValue(true);
            
            modelBuilder.Entity<Compliance>()
                .HasOne(co => co.criterion)
                .WithMany(cr => cr.compliances)
                .HasForeignKey(co => co.criterionId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Evidence>().HasKey(e => e.evidenceId);
            modelBuilder.Entity<Evidence>()
                .Property(e => e.isApplicable)
                .HasDefaultValue(true);

            modelBuilder.Entity<Evidence>()
                .HasOne(e => e.compliance)
                .WithMany(co => co.evidence)
                .HasForeignKey(e => e.complianceId)
                .OnDelete(DeleteBehavior.Cascade);


            //location relationships
            modelBuilder.Entity<Region>().HasKey(r => r.regionId);
            
            modelBuilder.Entity<Province>().HasKey(p => p.provinceId);
            modelBuilder.Entity<Province>()
                .HasOne(p => p.region)
                .WithMany(p => p.provinces)
                .HasForeignKey(p => p.regionId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<District>().HasKey(d => d.districtId);
            modelBuilder.Entity<District>()
                .HasOne(d => d.province)
                .WithMany(p => p.districts)
                .HasForeignKey(d => d.provinceId)
                .OnDelete(DeleteBehavior.Restrict);

            //facility relationships
            modelBuilder.Entity<Facility>().HasKey(f => f.facilityId);
            modelBuilder.Entity<Facility>()
                .HasOne(l => l.level)
                .WithMany(f => f.facilities)
                .HasForeignKey(f => f.levelId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Facility>()
                .HasOne(d => d.district)
                .WithMany(f => f.facilities)
                .HasForeignKey(f => f.districtId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Facility>()
                .HasOne(cr => cr.creditationStatus)
                .WithMany(f => f.facilities)
                .HasForeignKey(f => f.creditationStatusId)
                .OnDelete(DeleteBehavior.Restrict);
            
            modelBuilder.Entity<Facility>()
                .HasOne(o => o.organization)
                .WithMany(f => f.facilities)
                .HasForeignKey(f => f.organizationId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Facility>()
                .HasMany(f => f.surveys)
                .WithOne(s => s.facilities)
                .HasForeignKey(s => s.facilityId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<CreditationStatus>().HasKey(cr => cr.creditaitonStatusId);
            modelBuilder.Entity<Organization>().HasKey(o => o.organizationId);
            modelBuilder.Entity<Organization>()
                .HasOne(c => c.category)
                .WithMany(o => organizations)
                .HasForeignKey(o => o.categoryId)
                .OnDelete(DeleteBehavior.Restrict);
            
            modelBuilder.Entity<Category>().HasKey(c => c.categoryId);
            modelBuilder.Entity<Level>().HasKey(l => l.levelId);

            //user accounts relationships
            modelBuilder.Entity<Role>().HasKey(r => r.roleId);
            modelBuilder.Entity<Role>()
                .HasMany(r => r.userAccounts)
                .WithOne(ua => ua.role)
                .HasForeignKey(ua => ua.roleId)
                .OnDelete(DeleteBehavior.Restrict);
            
            modelBuilder.Entity<UserAccount>().HasKey(ua => ua.userAccountId);

            modelBuilder.Entity<User>().HasKey(u => u.userId);
            modelBuilder.Entity<User>()
                .HasOne(ua => ua.userAccount)
                .WithOne(u => u.user)
                .HasForeignKey<User>(ua => ua.userAccountId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<User>()
                .HasOne(u => u.organization)
                .WithMany(o => o.users)
                .HasForeignKey(u => u.organizationId)
                .OnDelete(DeleteBehavior.Restrict);
            
            //score and risk rating
            modelBuilder.Entity<Score>().HasKey(s => s.scoreId);
            modelBuilder.Entity<RiskRating>().HasKey(r => r.riskId);

            //surveys relationships
            modelBuilder.Entity<SurveyorCertStatus>().HasKey(sc => sc.surveyorCertStatusId);
            modelBuilder.Entity<SurveyorCertStatus>()
                .HasMany(sc => sc.surveyors)
                .WithOne(s => s.surveyorCertStatus)
                .HasForeignKey(s => s.surveyorCertStatusId)
                .OnDelete(DeleteBehavior.Restrict);
            
            modelBuilder.Entity<Specialization>().HasKey(sp => sp.specializationId);
            modelBuilder.Entity<Specialization>()
                .HasMany(sp => sp.surveyors)
                .WithOne(s => s.specialization)
                .HasForeignKey(s => s.specializationId)
                .OnDelete(DeleteBehavior.Restrict);
            
            modelBuilder.Entity<Surveyors>().HasKey(s => s.surveyorId);
            modelBuilder.Entity<Surveyors>()
                .HasMany(s => s.surveys)
                .WithOne(sv => sv.surveyor)
                .HasForeignKey(sv => sv.surveyorId)
                .OnDelete(DeleteBehavior.Restrict);
            
            modelBuilder.Entity<SurveyType>().HasKey(st => st.surveyTypeId);
            modelBuilder.Entity<SurveyType>()
                .HasMany(st => st.surveys)
                .WithOne(s => s.surveyType)
                .HasForeignKey(s => s.surveyTypeId)
                .OnDelete(DeleteBehavior.Restrict);
            
            modelBuilder.Entity<Survey>().HasKey(sv => sv.surveyId);
        }
    }
}