from rest_framework import generics
from .models import CustomUser, Chama, ChamaMembership
from .serializers import CustomUserSerializer, ChamaSerializer
from django.contrib.auth import authenticate
from rest_framework.response import Response
from rest_framework import status
from django.views.generic import ListView
from django.http import JsonResponse


class RegisterUserView(generics.CreateAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = CustomUserSerializer


class RegisterChamaView(generics.CreateAPIView):
    queryset = Chama.objects.all()
    serializer_class = ChamaSerializer


class LoginView(generics.GenericAPIView):
    serializer_class = CustomUserSerializer

    def post(self, request, *args, **kwargs):
        username = request.data.get('username')
        password = request.data.get('password')
        
        # Authenticate the user
        user = authenticate(request, username=username, password=password)
        
        if user is not None:
            # User is authenticated, gather user details
            user_data = {
                'user_id': user.id,
                'first_name': user.first_name,
                'last_name': user.last_name,
                'username': user.username,
                'email': user.email,
                'national_id': user.national_id,
                'mobile_no': user.mobile_no,
                'user_role': user.user_role  # Include user role
            }
            
            # Try to fetch ChamaMembership details
            try:
                chama_membership = ChamaMembership.objects.get(user=user)
                chama = chama_membership.chama
                
                # Add Chama details to the response
                user_data['chama'] = {
                    'chama_id': chama.id,
                    'chama_name': chama.chama_name
                }
                
            except ChamaMembership.DoesNotExist:
                # Handle case where user does not belong to any Chama
                user_data['chama'] = None

            return Response({'message': 'Login successful', 'user': user_data}, status=status.HTTP_200_OK)
             
      

class ChamaListView(ListView):
    model = Chama
    context_object_name = 'chamas'

    def render_to_response(self, context, **response_kwargs):
        chamas = []
        # Loop through each chama and gather its details
        for chama in context['chamas']:
            # Count the number of members belonging to this chama
            members_count = ChamaMembership.objects.filter(chama=chama).count()
            
            # Get the admin of this chama
            admin_membership = ChamaMembership.objects.filter(chama=chama, is_admin=True).first()
            admin = admin_membership.user.username if admin_membership else None

            # Collect chama details
            chama_data = {
                'id': chama.id,
                'chama_name': chama.chama_name,
                'registration_no': chama.registration_no,
                'location': chama.location,
                'meet_schedule': chama.meet_schedule,
                'day_or_date': chama.day_or_date,
                'members_count': members_count,
                'admin': admin,
            }
            chamas.append(chama_data)

        # Check if there are chamas to return
        if chamas:
            return JsonResponse(chamas, safe=False)
        else:
            return JsonResponse({'error': 'No chamas found'}, status=404)
        
        
              