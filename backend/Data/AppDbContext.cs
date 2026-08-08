using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using backend.Models.Framework;

namespace backend.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions options) : base(options)
        {
            
        }
        
        //db sets for all the tables
        public DbSet<Function> functions { get; set; }
        public DbSet<Component> components { get; set; }
        public DbSet<Standard> standards { get; set; }
        public DbSet<Criterion> criteria { get; set; }
        public DbSet<Compliance> compliances { get; set; }
        public DbSet<Evidence> evidence { get; set; }

        //database relationships between the tables created...
        //Framework relationships
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

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
                .HasForeignKey(s => s.componentId);

            modelBuilder.Entity<Standard>()
                .HasOne(s => s.function)
                .WithMany(f => f.standards)
                .HasForeignKey(s => s.functionId);

            modelBuilder.Entity<Criterion>().HasKey(cr => cr.criterionId);
            modelBuilder.Entity<Criterion>()
                .HasIndex(cr => cr.criterionNumber)
                .IsUnique();

            modelBuilder.Entity<Criterion>()
                .Property(cr => cr.isApplicable)
                .HasDefaultValue(true);
            
            modelBuilder.Entity<Criterion>()
                .HasOne(cr => cr.standard)
                .WithMany(s => s.criteria)
                .HasForeignKey(cr => cr.standardId);

            modelBuilder.Entity<Compliance>().HasKey(co => co.complianceId);
            modelBuilder.Entity<Compliance>()
                .HasIndex(co => co.complianceNumber)
                .IsUnique();
                
            modelBuilder.Entity<Compliance>()
                .Property(co => co.isApplicable)
                .HasDefaultValue(true);
            
            modelBuilder.Entity<Compliance>()
                .HasOne(co => co.criterion)
                .WithMany(cr => cr.compliances)
                .HasForeignKey(co => co.criterionId);

            modelBuilder.Entity<Evidence>().HasKey(e => e.evidenceId);
            modelBuilder.Entity<Evidence>()
                .Property(e => e.isApplicable)
                .HasDefaultValue(true);

            modelBuilder.Entity<Evidence>()
                .HasOne(e => e.compliance)
                .WithMany(co => co.evidence)
                .HasForeignKey(e => e.complianceId);
        }
    }
}