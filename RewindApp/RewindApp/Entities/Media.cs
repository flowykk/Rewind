using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace RewindApp.Entities;

public class Media
{
    [Key] public int Id { get; set; }
    [Required] public DateTime Date { get; set; }
    [Required] public byte[] Object { get; set; } = Array.Empty<byte>();
    [Required] public byte[] TinyObject { get; set; } = Array.Empty<byte>();
    // public User User { get; set; }
    [IgnoreDataMember] public ICollection<Tag> Tags { get; set; } = new List<Tag>();
    [IgnoreDataMember] public ICollection<User> Users { get; set; } = new List<User>();
    [IgnoreDataMember] public Group Group { get; set; }
}