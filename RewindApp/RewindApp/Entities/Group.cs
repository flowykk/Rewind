using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RewindApp.Entities;

public class Group
{
    [Key]
    public int GroupsId { get; set; }
    [Required]
    public int OwnerId { get; set; }
    [Required, MaxLength(128)]
    public string GroupName { get; set; } = string.Empty;
    [Required]
    public byte[] GroupImage { get; set; } = Array.Empty<byte>();

    public ICollection<User> Users { get; set; } = new List<User>();
}
 