from rest_framework import generics
from .models import CustomUser, Chama
from .serializers import CustomUserSerializer, ChamaSerializer

class RegisterUserView(generics.CreateAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = CustomUserSerializer

class RegisterChamaView(generics.CreateAPIView):
    queryset = Chama.objects.all()
    serializer_class = ChamaSerializer
