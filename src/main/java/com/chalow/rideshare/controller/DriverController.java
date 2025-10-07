package com.chalow.rideshare.controller;

import com.chalow.rideshare.dto.*;
import com.chalow.rideshare.entity.RideRequest;
import com.chalow.rideshare.repository.RideRequestRepository;
import com.chalow.rideshare.service.*;
import jakarta.validation.Valid;
import org.locationtech.jts.geom.Point;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/v1/driver")
@PreAuthorize("isAuthenticated()")
public class DriverController {
    public static final String ERROR = "ERROR";
    private static final Logger LOG = LoggerFactory.getLogger(DriverController.class);
    private final RideService rideService;
    private final UserService userService;
    private final DriverService driverService;
    private final RideRequestRepository rideRequestRepository;
    private final DistanceService distanceService;
    private DocumentVerificationManagementService documentVerificationManagementService;

    public DriverController(RideService rideService, UserService userService, DriverService driverService, RideRequestRepository rideRequestRepository, DistanceService distanceService) {
        this.rideService = rideService;
        this.userService = userService;
        this.driverService = driverService;
        this.rideRequestRepository = rideRequestRepository;
        this.distanceService = distanceService;
    }

    @GetMapping("/profile")
    public ResponseEntity<DriverDTO.DriverProfileResponse> getDriverProfile(Authentication authentication) {
        try {
            LOG.info("Getting driver profile for: {}", authentication.getName());
            UserDTO.UserResponse currentUser = userService.getCurrentUserOrCreate(authentication);
            DriverDTO.DriverProfileResponse driverProfile = driverService.getDriverProfile(currentUser.getId());
            return ResponseEntity.ok(driverProfile);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    // minimal other endpoints omitted for brevity — the real controller has many endpoints
}
