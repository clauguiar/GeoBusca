"""geobusca01_acre_site URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.urls import include, path
from django.contrib.auth.models import User
from rest_framework import routers, serializers, viewsets
from django.contrib.gis import admin
from django.contrib.staticfiles.storage import staticfiles_storage
from django.views.generic.base import RedirectView

# Serializers define the API representation.
class UserSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = User
        fields = ('url', 'username', 'email', 'is_staff')

# ViewSets define the view behavior.
class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

# Routers provide an easy way of automatically determining the URL conf.
router = routers.DefaultRouter()
router.register(r'users', UserViewSet)

# Wire up our API using automatic URL routing.
# Additionally, we include login URLs for the browsable API.

urlpatterns = [
    # autorização Rest
#    path('', include('router.urls')),
    # /
    path('', include('geobusca01_acre_app.urls')),
    # /api-auth/ Rest Framework browsable API
    path('api-auth/', include('rest_framework.urls')),
    # /admin/
    path('admin/', admin.site.urls),
    path('favicon.ico',
        RedirectView.as_view( # the redirecting function
            url=staticfiles_storage.url('geobusca01_acre_app/icon/favicon.ico'), # converts the static directory + our favicon into a URL
            # in my case, the result would be http://www.tumblingprogrammer.com/static/img/favicon.ico
        ),
        name="favicon" # name of our view
    ),
]
