from django.urls import path
from .views import RegisterUserView, RegisterChamaView, LoginView

urlpatterns = [
    path('register_user/', RegisterUserView.as_view(), name='register_user'),
    path('register_chama/', RegisterChamaView.as_view(), name='register_chama'),
    path('login/', LoginView.as_view(), name='login'),
]
