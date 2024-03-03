using Microsoft.EntityFrameworkCore;
using RewindApp.Entities;

namespace RewindApp.Data;

public class DataContext : DbContext
{
    public DataContext(DbContextOptions<DataContext> options) : base(options)
    {
    }

    public DbSet<User> Users => Set<User>();
    public DbSet<Group> Groups => Set<Group>(); 
    public DbSet<Media> Media => Set<Media>();
    public DbSet<Tag> Tags => Set<Tag>();
}