using Microsoft.EntityFrameworkCore;
using RewindApp.Models;

namespace RewindApp.Data;

public class DataContext : DbContext
{
    public DataContext(DbContextOptions<DataContext> options) : base(options)
    {
    }
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        /*modelBuilder.Entity<User>()
            .HasMany(e => e.Groups)
            .WithMany(e => e.Members);*/
    }

    public DbSet<User> Users => Set<User>();
    public DbSet<Groups> Groups => Set<Groups>(); 
    public DbSet<Media> Media => Set<Media>();
    public DbSet<GroupMembers> GroupMembers => Set<GroupMembers>();
}