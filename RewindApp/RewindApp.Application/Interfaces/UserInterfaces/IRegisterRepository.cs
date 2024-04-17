using RewindApp.Domain.Entities;
using RewindApp.Domain.Requests.UserRequests;

namespace RewindApp.Application.Interfaces.UserInterfaces;

public interface IRegisterRepository
{ 
    Task<User> RegisterUserAsync(UserRegisterRequest request);
}