using AutoFixture;
using RewindApp.Domain.Entities;
using RewindApp.Domain.Requests;
using RewindApp.Domain.Requests.ChangeRequests;
using RewindApp.Domain.Requests.MediaRequests;
using RewindApp.Domain.Requests.UserRequests;
using RewindApp.Domain.Views;
using RewindApp.Infrastructure.Data;

namespace RewindApp.Tests;

public static class ContextHelper
{
    private static Fixture _fixture = new Fixture();
    public static UserRegisterRequest BuildTestRegisterRequest() 
    {
        return _fixture
            .Build<UserRegisterRequest>()
            .With(req => req.Email, "test@test.test")
            .With(req => req.Password, "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08")
            .Create();
    }
    
    public static UserRegisterRequest BuildExtraUserRegisterRequest()//int extraUserId) 
    {
        return _fixture
            .Build<UserRegisterRequest>()
            //.With(req => req.Id, extraUserId)
            .Create();
    }
    
    public static UserLoginRequest BuildTestLoginRequest() 
    {
        return _fixture
            .Build<UserLoginRequest>()
            .With(req => req.Email, "test@test.test")
            .With(req => req.Password, "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08")
            .Create();
    }
    
    public static UserLoginRequest BuildInvalidEmailLoginRequest() 
    {
        return _fixture
            .Build<UserLoginRequest>()
            .With(req => req.Email, "no@no.no")
            .With(req => req.Password, "test")
            .Create();
    }
    
    public static UserLoginRequest BuildInvalidPasswordLoginRequest() 
    {
        return _fixture
            .Build<UserLoginRequest>()
            .With(req => req.Email, "test@test.test")
            .With(req => req.Password, "no")
            .Create();
    }

    public static CreateGroupRequest BuildInvalidOwnerIdCreateGroupRequest()
    {
        return _fixture
            .Build<CreateGroupRequest>()
            .With(req => req.OwnerId, 2)
            .With(req => req.GroupName, "defaultName")
            .Create();
    }
    
    public static CreateGroupRequest BuildTestCreateGroupRequest()
    {
        return _fixture
            .Build<CreateGroupRequest>()
            .With(req => req.OwnerId, 1)
            .With(req => req.GroupName, "defaultName")
            .Create();
    }

    public static MediaRequest BuildTestChangeImageRequest()
    {
        return _fixture
            .Build<MediaRequest>()
            .With(req => req.Object, "VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIDEzIGxhenkgZG9ncy4=")
            .With(req => req.TinyObject, "VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIDEzIGxhenkgZG9ncy4=")
            .Create();
    }
    
    public static LoadMediaRequest BuildLoadMediaRequest()
    {
        return _fixture
            .Build<LoadMediaRequest>()
            .With(req => req.Object, "VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIDEzIGxhenkgZG9ncy4=")
            .With(req => req.TinyObject, "VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIDEzIGxhenkgZG9ncy4=")
            .With(req => req.IsPhoto, 1)
            .With(req => req.Tags, new List<string>())
            .Create();
    }
    
    public static TextRequest BuildDefaultTagTextRequest()
    {
        return _fixture.Build<TextRequest>()
            .With(req => req.Text, "test")
            .Create();;
    }

    public static TagsRequest BuildDefaultTagsRequest()
    {
        return _fixture.Build<TagsRequest>()
            .With(req => req.Tags, new List<string> {"test"})
            .Create();
    }

    public static async Task LoadMedia(LoadMediaRequest request, DataContext context, Group group, User user)
    {
        var media = new Media
        {
            Object = Convert.FromBase64String(request.Object),
            TinyObject = Convert.FromBase64String(request.TinyObject),
            IsPhoto = request.IsPhoto == 1,
            Author = new UserView
            {
                Id = user.Id,
                TinyProfileImage = user.TinyProfileImage,
                UserName = user.UserName
            },
            Group = group
        };
        
        context.Media.Add(media);
        await context.SaveChangesAsync();
    }
}