using Microsoft.EntityFrameworkCore;
using RewindApp.Models;

namespace RewindApp.Data;

public class DataContext : DbContext
{
    public DataContext(DbContextOptions<DataContext> options) : base(options)
    {
    }

    public DbSet<Users> Users => Set<Users>();
    public DbSet<Groups> Groups => Set<Groups>(); 
    public DbSet<Media> Media => Set<Media>();
}