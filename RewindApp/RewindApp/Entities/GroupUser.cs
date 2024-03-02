using Microsoft.EntityFrameworkCore;

namespace RewindApp.Entities;

[Keyless]
public class GroupUser
{
    //[ForeignKey(nameof(User))]
    public int UsersId { get; set; }
    //[ForeignKey(nameof(Group))]
    public int GroupsId { get; set; }
}