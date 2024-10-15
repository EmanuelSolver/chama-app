from django.contrib import admin
from .models import CustomUser, Chama, ChamaMembership

# Register your models here.
admin.site.register(CustomUser)
admin.site.register(Chama)
admin.site.register(ChamaMembership)
