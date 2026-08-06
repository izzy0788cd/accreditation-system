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
            modelBuilder.Entity<Function>().HasKey(f => f.functionId);

            modelBuilder.Entity<Standard>().HasKey(s => s.standardId);
            modelBuilder.Entity<Standard>()
                .HasOne(c => c.component)
                .WithMany(s => s.standards)
                .HasForeignKey(c => c.componentId);
            modelBuilder.Entity<Standard>()
                .HasOne(f => f.function)
                .WithMany(s => s.standards)
                .HasForeignKey(f => f.functionId);

            modelBuilder.Entity<Criterion>().HasKey(cr => cr.criterionId);
            modelBuilder.Entity<Criterion>()
                .HasOne(s => s.standard)
                .WithMany(cr => cr.criteria)
                .HasForeignKey(s => s.standardId);

            modelBuilder.Entity<Compliance>().HasKey(co => co.complianceId);
            modelBuilder.Entity<Compliance>()
                .HasOne(cr => cr.criterion)
                .WithMany(co => co.compliances)
                .HasForeignKey(cr => cr.criterionId);

            modelBuilder.Entity<Evidence>().HasKey(e => e.evidenceId);
            modelBuilder.Entity<Evidence>()
                .HasOne(co => co.compliance)
                .WithMany(e => e.evidence)
                .HasForeignKey(co => co.complianceId);
        }
    }
}