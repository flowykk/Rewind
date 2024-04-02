using Microsoft.AspNetCore.Mvc;
using RewindApp.Entities;
using RewindApp.Requests.UserRequests;

namespace RewindApp.Interfaces.UserInterfaces;

public interface IRegisterRepository
{
    int CheckEmailAsync(string email);
    Task<User> RegisterUserAsync(UserRegisterRequest request);
    
}