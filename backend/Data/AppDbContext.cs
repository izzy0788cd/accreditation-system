using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using backend.Models.Framework;
using backend.Models.Location;

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
        }
    }
}