using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace RewindApp.Entities;

public class User
{
    [Key] public int Id { get; set; }
    [Required, MaxLength(128)] public string UserName { get; set; } = string.Empty;
    [Required, MaxLength(128)] public string Email { get; set; } = string.Empty;
    [Required, MaxLength(128), IgnoreDataMember] public string Password { get; set; } = string.Empty;
    [Required] public DateTime RegistrationDateTime { get; set; } = DateTime.Now;
    [Required] public byte[] ProfileImage { get; set; } = Array.Empty<byte>();
    [Required] public byte[] TinyProfileImage { get; set; } = Array.Empty<byte>();
    [MaxLength(128)] public string AppIcon { get; set; } = "AppIconWhite";

    [IgnoreDataMember] public ICollection<Group> Groups { get; set; } = new List<Group>();
    
    [IgnoreDataMember] public ICollection<Media> Media { get; set; } = new List<Media>();
}