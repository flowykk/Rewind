using RewindApp.Domain.Entities;
using RewindApp.Domain.Requests;
using RewindApp.Domain.Requests.ChangeRequests;

namespace RewindApp.Application.Interfaces.GroupInterfaces;

public interface IChangeGroupRepository
{
    Task ChangeName(Group group, TextRequest request);
    Task ChangeImage(Group group, MediaRequest mediaRequest);
}