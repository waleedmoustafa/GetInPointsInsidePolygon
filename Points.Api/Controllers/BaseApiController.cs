using Microsoft.AspNetCore.Mvc;
using Points.Api.Configuration;

namespace Points.Api.Controllers
{
    public class BaseApiController : ControllerBase
    {
        protected readonly IJsonFieldsSerializer JsonFieldsSerializer;
        public BaseApiController(IJsonFieldsSerializer jsonFieldsSerializer)
        {
            JsonFieldsSerializer = jsonFieldsSerializer;
        }

    }
}
