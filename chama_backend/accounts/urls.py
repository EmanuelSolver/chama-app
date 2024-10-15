from django.urls import path
from .views import RegisterUserView, RegisterChamaView, LoginView, ChamaListView

urlpatterns = [
    path('register_member/', RegisterUserView.as_view(), name='register_member'),
    path('register_chama/', RegisterChamaView.as_view(), name='register_chama'),
    path('login/', LoginView.as_view(), name='login'),
    path('get_chamas/', ChamaListView.as_view(), name='chama-list'),  

]
