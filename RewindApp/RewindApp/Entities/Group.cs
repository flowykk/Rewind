using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;

namespace RewindApp.Entities;

public class Group
{
    [Key] public int Id { get; set; }
    [Required] public int OwnerId { get; set; }
    [Required, MaxLength(128)] public string Name { get; set; } = string.Empty;
    [Required] public byte[] Image { get; set; } = Array.Empty<byte>();

    [IgnoreDataMember] public ICollection<User> Users { get; set; } = new List<User>();
    [IgnoreDataMember] public ICollection<Media> Media { get; set; } = new List<Media>();
}
 