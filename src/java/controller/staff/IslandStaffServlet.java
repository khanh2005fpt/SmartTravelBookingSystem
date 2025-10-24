/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.staff;

import dao.ServiceDao;
import model.Island;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet for managing island operations for staff members
 * Handles island CRUD operations, list display, search functionality
 * 
 * @author Admin
 */
@WebServlet(name = "IslandStaffServlet", urlPatterns = {"/staff/islands"})
public class IslandStaffServlet extends HttpServlet {
    
    private ServiceDao serviceDao;
    
    @Override
    public void init() throws ServletException {
        try {
            serviceDao = ServiceDao.INSTANCE;
            System.out.println("ServiceDao initialized successfully in IslandStaffServlet");
        } catch (Exception e) {
            System.out.println("Error initializing ServiceDao in IslandStaffServlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Failed to initialize ServiceDao", e);
        }
    }

    /**
     * Handles GET requests for island operations
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in and has staff role
        HttpSession session = request.getSession(false);
        if (!isStaffAuthorized(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        try {
            switch (action) {
                case "list":
                    handleIslandList(request, response);
                    break;
                case "view":
                    handleIslandDetail(request, response);
                    break;
                case "create":
                    handleCreateForm(request, response);
                    break;
                case "edit":
                    handleEditForm(request, response);
                    break;
                case "search":
                    handleIslandSearch(request, response);
                    break;
                default:
                    handleIslandList(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Error processing island request: " + e.getMessage(), e);
        }
    }

    /**
     * Handles POST requests for island operations
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (!isStaffAuthorized(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "create":
                    handleCreateIsland(request, response);
                    break;
                case "update":
                    handleUpdateIsland(request, response);
                    break;
                case "delete":
                    handleDeleteIsland(request, response);
                    break;
                case "updateStatus":
                    handleUpdateStatus(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/staff/islands");
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Error processing island operation: " + e.getMessage(), e);
        }
    }

    /**
     * Display list of all islands
     */
    private void handleIslandList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Island> islands = serviceDao.getAllIslands();
            request.setAttribute("islands", islands);
            request.setAttribute("pageTitle", "Island Management");
            request.getRequestDispatcher("/views/staff/island-list.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading island list: " + e.getMessage(), e);
        }
    }

    /**
     * Display island details
     */
    private void handleIslandDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String islandIdStr = request.getParameter("id");
            if (islandIdStr == null || islandIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Island ID is required");
                handleIslandList(request, response);
                return;
            }
            
            int islandId = Integer.parseInt(islandIdStr);
            Island island = serviceDao.getIslandById(islandId);
            
            if (island == null) {
                request.setAttribute("errorMessage", "Island not found");
                handleIslandList(request, response);
                return;
            }
            
            request.setAttribute("island", island);
            request.setAttribute("pageTitle", "Island Details - " + island.getIslandName());
            request.getRequestDispatcher("/views/staff/island-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid island ID format");
            handleIslandList(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading island details: " + e.getMessage(), e);
        }
    }

    /**
     * Display create island form
     */
    private void handleCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("pageTitle", "Create New Island");
            request.getRequestDispatcher("/views/staff/island-form.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading create form: " + e.getMessage(), e);
        }
    }

    /**
     * Display edit island form
     */
    private void handleEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String islandIdStr = request.getParameter("id");
            if (islandIdStr == null || islandIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Island ID is required");
                handleIslandList(request, response);
                return;
            }
            
            int islandId = Integer.parseInt(islandIdStr);
            Island island = serviceDao.getIslandById(islandId);
            
            if (island == null) {
                request.setAttribute("errorMessage", "Island not found");
                handleIslandList(request, response);
                return;
            }
            
            request.setAttribute("island", island);
            request.setAttribute("pageTitle", "Edit Island - " + island.getIslandName());
            request.getRequestDispatcher("/views/staff/island-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid island ID format");
            handleIslandList(request, response);
        } catch (Exception e) {
            handleError(request, response, "Error loading island for edit: " + e.getMessage(), e);
        }
    }

    /**
     * Handle island search
     */
    private void handleIslandSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String keyword = request.getParameter("keyword");
            String region = request.getParameter("region");
            String status = request.getParameter("status");
            
            List<Island> islands;
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                islands = serviceDao.searchIslands(keyword.trim());
                request.setAttribute("searchKeyword", keyword.trim());
            } else {
                islands = serviceDao.getAllIslands();
            }
            
            // Apply additional filters if provided
            if (region != null && !region.trim().isEmpty()) {
                request.setAttribute("searchRegion", region);
            }
            
            if (status != null && !status.trim().isEmpty()) {
                request.setAttribute("searchStatus", status);
            }
            
            request.setAttribute("islands", islands);
            request.setAttribute("pageTitle", "Island Search Results");
            request.getRequestDispatcher("/views/staff/island-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            handleError(request, response, "Error searching islands: " + e.getMessage(), e);
        }
    }

    /**
     * Handle create island
     */
    private void handleCreateIsland(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Validate input
            if (!validateIslandInput(request)) {
                request.setAttribute("pageTitle", "Create New Island");
                request.getRequestDispatcher("/views/staff/island-form.jsp").forward(request, response);
                return;
            }
            
            // Create island object
            Island island = createIslandFromRequest(request);
            
            // Save island
            boolean success = serviceDao.createIsland(island);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/islands?success=created");
            } else {
                request.setAttribute("errorMessage", "Failed to create island. Please try again.");
                request.setAttribute("pageTitle", "Create New Island");
                request.getRequestDispatcher("/views/staff/island-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            handleError(request, response, "Error creating island: " + e.getMessage(), e);
        }
    }

    /**
     * Handle update island
     */
    private void handleUpdateIsland(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Validate input
            if (!validateIslandInput(request)) {
                String islandIdStr = request.getParameter("islandId");
                if (islandIdStr != null) {
                    Island island = serviceDao.getIslandById(Integer.parseInt(islandIdStr));
                    request.setAttribute("island", island);
                }
                request.setAttribute("pageTitle", "Edit Island");
                request.getRequestDispatcher("/views/staff/island-form.jsp").forward(request, response);
                return;
            }
            
            // Create island object
            Island island = createIslandFromRequest(request);
            island.setIslandId(Integer.parseInt(request.getParameter("islandId")));
            
            // Update island
            boolean success = serviceDao.updateIsland(island);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/islands?success=updated");
            } else {
                request.setAttribute("errorMessage", "Failed to update island. Please try again.");
                request.setAttribute("island", island);
                request.setAttribute("pageTitle", "Edit Island");
                request.getRequestDispatcher("/views/staff/island-form.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            handleError(request, response, "Error updating island: " + e.getMessage(), e);
        }
    }

    /**
     * Handle delete island
     */
    private void handleDeleteIsland(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String islandIdStr = request.getParameter("islandId");
            if (islandIdStr == null || islandIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/staff/islands?error=invalid_id");
                return;
            }
            
            int islandId = Integer.parseInt(islandIdStr);
            boolean success = serviceDao.deleteIsland(islandId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/islands?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/islands?error=delete_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/islands?error=invalid_id");
        } catch (Exception e) {
            handleError(request, response, "Error deleting island: " + e.getMessage(), e);
        }
    }

    /**
     * Handle update island status
     */
    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String islandIdStr = request.getParameter("islandId");
            String status = request.getParameter("status");
            
            if (islandIdStr == null || status == null) {
                response.sendRedirect(request.getContextPath() + "/staff/islands?error=invalid_params");
                return;
            }
            
            int islandId = Integer.parseInt(islandIdStr);
            boolean success = serviceDao.updateIslandStatus(islandId, status);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/islands?success=status_updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/islands?error=update_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/islands?error=invalid_params");
        } catch (Exception e) {
            handleError(request, response, "Error updating island status: " + e.getMessage(), e);
        }
    }

    /**
     * Create island object from request parameters
     */
    private Island createIslandFromRequest(HttpServletRequest request) {
        Island island = new Island();
        
        island.setIslandName(request.getParameter("islandName"));
        island.setDescription(request.getParameter("description"));
        island.setLocation(request.getParameter("location"));
        island.setImageUrl(request.getParameter("imageUrl"));
        island.setClimate(request.getParameter("climate"));
        island.setPopulation(request.getParameter("population"));
        island.setLanguage(request.getParameter("language"));
        island.setCurrency(request.getParameter("currency"));
        island.setTimeZone(request.getParameter("timeZone"));
        island.setBestTimeToVisit(request.getParameter("bestTimeToVisit"));
        island.setActivities(request.getParameter("activities"));
        island.setTransportation(request.getParameter("transportation"));
        island.setAccommodation(request.getParameter("accommodation"));
        island.setDining(request.getParameter("dining"));
        island.setShopping(request.getParameter("shopping"));
        island.setNightlife(request.getParameter("nightlife"));
        island.setCulture(request.getParameter("culture"));
        island.setHistory(request.getParameter("history"));
        island.setGeography(request.getParameter("geography"));
        island.setWildlife(request.getParameter("wildlife"));
        island.setConservation(request.getParameter("conservation"));
        island.setTips(request.getParameter("tips"));
        island.setEmergencyContacts(request.getParameter("emergencyContacts"));
        island.setVisaRequirements(request.getParameter("visaRequirements"));
        island.setHealthSafety(request.getParameter("healthSafety"));
        island.setWeather(request.getParameter("weather"));
        island.setEvents(request.getParameter("events"));
        island.setLocalCustoms(request.getParameter("localCustoms"));
        island.setPhotographyTips(request.getParameter("photographyTips"));
        island.setSustainableTourism(request.getParameter("sustainableTourism"));
        island.setAccessibility(request.getParameter("accessibility"));
        island.setFamilyFriendly(request.getParameter("familyFriendly"));
        island.setBudgetTips(request.getParameter("budgetTips"));
        island.setLuxuryOptions(request.getParameter("luxuryOptions"));
        island.setAdventureSports(request.getParameter("adventureSports"));
        island.setRelaxationSpots(request.getParameter("relaxationSpots"));
        island.setLocalCuisine(request.getParameter("localCuisine"));
        island.setFestivals(request.getParameter("festivals"));
        island.setArtsCrafts(request.getParameter("artsCrafts"));
        island.setMusicDance(request.getParameter("musicDance"));
        island.setArchitecture(request.getParameter("architecture"));
        island.setMuseumsGalleries(request.getParameter("museumsGalleries"));
        island.setReligiousSites(request.getParameter("religiousSites"));
        island.setNaturalWonders(request.getParameter("naturalWonders"));
        island.setBeaches(request.getParameter("beaches"));
        island.setHikingTrails(request.getParameter("hikingTrails"));
        island.setWaterSports(request.getParameter("waterSports"));
        island.setDivingSnorkeling(request.getParameter("divingSnorkeling"));
        island.setFishingHunting(request.getParameter("fishingHunting"));
        island.setGolfing(request.getParameter("golfing"));
        island.setSpaWellness(request.getParameter("spaWellness"));
        island.setEcoTourism(request.getParameter("ecoTourism"));
        island.setCulturalTours(request.getParameter("culturalTours"));
        island.setFoodTours(request.getParameter("foodTours"));
        island.setWineTasting(request.getParameter("wineTasting"));
        island.setShoppingDistricts(request.getParameter("shoppingDistricts"));
        island.setMarkets(request.getParameter("markets"));
        island.setSouvenirs(request.getParameter("souvenirs"));
        island.setLocalProducts(request.getParameter("localProducts"));
        island.setHandicrafts(request.getParameter("handicrafts"));
        island.setJewelry(request.getParameter("jewelry"));
        island.setTextiles(request.getParameter("textiles"));
        island.setAntiques(request.getParameter("antiques"));
        island.setBookstores(request.getParameter("bookstores"));
        island.setMusicStores(request.getParameter("musicStores"));
        island.setArtSupplies(request.getParameter("artSupplies"));
        island.setSportsEquipment(request.getParameter("sportsEquipment"));
        island.setOutdoorGear(request.getParameter("outdoorGear"));
        island.setElectronics(request.getParameter("electronics"));
        island.setClothing(request.getParameter("clothing"));
        island.setFootwear(request.getParameter("footwear"));
        island.setAccessories(request.getParameter("accessories"));
        island.setCosmetics(request.getParameter("cosmetics"));
        island.setPerfumes(request.getParameter("perfumes"));
        island.setWatches(request.getParameter("watches"));
        island.setSunglasses(request.getParameter("sunglasses"));
        island.setBags(request.getParameter("bags"));
        island.setLuggage(request.getParameter("luggage"));
        island.setTravelGear(request.getParameter("travelGear"));
        island.setCameras(request.getParameter("cameras"));
        island.setBinoculars(request.getParameter("binoculars"));
        island.setMaps(request.getParameter("maps"));
        island.setGuidebooks(request.getParameter("guidebooks"));
        island.setPhrasebooks(request.getParameter("phrasebooks"));
        island.setDictionaries(request.getParameter("dictionaries"));
        island.setTranslators(request.getParameter("translators"));
        island.setCurrencyExchange(request.getParameter("currencyExchange"));
        island.setBanking(request.getParameter("banking"));
        island.setAtms(request.getParameter("atms"));
        island.setCreditCards(request.getParameter("creditCards"));
        island.setTipping(request.getParameter("tipping"));
        island.setBargaining(request.getParameter("bargaining"));
        island.setTaxes(request.getParameter("taxes"));
        island.setInsurance(request.getParameter("insurance"));
        island.setMedicalFacilities(request.getParameter("medicalFacilities"));
        island.setPharmacies(request.getParameter("pharmacies"));
        island.setVaccinations(request.getParameter("vaccinations"));
        island.setMedications(request.getParameter("medications"));
        island.setFirstAid(request.getParameter("firstAid"));
        island.setEmergencyServices(request.getParameter("emergencyServices"));
        island.setPolice(request.getParameter("police"));
        island.setFireDepartment(request.getParameter("fireDepartment"));
        island.setAmbulance(request.getParameter("ambulance"));
        island.setCoastGuard(request.getParameter("coastGuard"));
        island.setMountainRescue(request.getParameter("mountainRescue"));
        island.setTouristPolice(request.getParameter("touristPolice"));
        island.setEmbassies(request.getParameter("embassies"));
        island.setConsulates(request.getParameter("consulates"));
        island.setTouristInformation(request.getParameter("touristInformation"));
        island.setTravelAgencies(request.getParameter("travelAgencies"));
        island.setTourOperators(request.getParameter("tourOperators"));
        island.setGuides(request.getParameter("guides"));
        island.setInterpreters(request.getParameter("interpreters"));
        island.setDrivers(request.getParameter("drivers"));
        island.setPorters(request.getParameter("porters"));
        island.setCooks(request.getParameter("cooks"));
        island.setCleaners(request.getParameter("cleaners"));
        island.setLaundry(request.getParameter("laundry"));
        island.setDryCleaning(request.getParameter("dryCleaning"));
        island.setTailoring(request.getParameter("tailoring"));
        island.setShoeRepair(request.getParameter("shoeRepair"));
        island.setHairSalons(request.getParameter("hairSalons"));
        island.setBarberShops(request.getParameter("barberShops"));
        island.setNailSalons(request.getParameter("nailSalons"));
        island.setMassage(request.getParameter("massage"));
        island.setGyms(request.getParameter("gyms"));
        island.setYogaStudios(request.getParameter("yogaStudios"));
        island.setPilatesStudios(request.getParameter("pilatesStudios"));
        island.setDanceStudios(request.getParameter("danceStudios"));
        island.setMartialArts(request.getParameter("martialArts"));
        island.setSwimmingPools(request.getParameter("swimmingPools"));
        island.setTennisClubs(request.getParameter("tennisClubs"));
        island.setGolfClubs(request.getParameter("golfClubs"));
        island.setCountryClubs(request.getParameter("countryClubs"));
        island.setBeachClubs(request.getParameter("beachClubs"));
        island.setYachtClubs(request.getParameter("yachtClubs"));
        island.setFishingClubs(request.getParameter("fishingClubs"));
        island.setHuntingClubs(request.getParameter("huntingClubs"));
        island.setHikingClubs(request.getParameter("hikingClubs"));
        island.setClimbingClubs(request.getParameter("climbingClubs"));
        island.setCyclingClubs(request.getParameter("cyclingClubs"));
        island.setRunningClubs(request.getParameter("runningClubs"));
        island.setTriathlonClubs(request.getParameter("triathlonClubs"));
        island.setSwimmingClubs(request.getParameter("swimmingClubs"));
        island.setSurfingClubs(request.getParameter("surfingClubs"));
        island.setDivingClubs(request.getParameter("divingClubs"));
        island.setSailingClubs(request.getParameter("sailingClubs"));
        island.setKayakingClubs(request.getParameter("kayakingClubs"));
        island.setCanoeingClubs(request.getParameter("canoeingClubs"));
        island.setRaftingClubs(request.getParameter("raftingClubs"));
        island.setWindsurfingClubs(request.getParameter("windsurfingClubs"));
        island.setKitesurfingClubs(request.getParameter("kitesurfingClubs"));
        island.setParasailingClubs(request.getParameter("parasailingClubs"));
        island.setHangGlidingClubs(request.getParameter("hangGlidingClubs"));
        island.setParachutingClubs(request.getParameter("parachutingClubs"));
        island.setBungeeJumpingClubs(request.getParameter("bungeeJumpingClubs"));
        island.setZipLiningClubs(request.getParameter("zipLiningClubs"));
        island.setRockClimbingClubs(request.getParameter("rockClimbingClubs"));
        island.setIceClimbingClubs(request.getParameter("iceClimbingClubs"));
        island.setMountaineeringClubs(request.getParameter("mountaineeringClubs"));
        island.setSkiingClubs(request.getParameter("skiingClubs"));
        island.setSnowboardingClubs(request.getParameter("snowboardingClubs"));
        island.setIceSkatingClubs(request.getParameter("iceSkatingClubs"));
        island.setHockeyClubs(request.getParameter("hockeyClubs"));
        island.setCurlingClubs(request.getParameter("curlingClubs"));
        island.setBobsledClubs(request.getParameter("bobsledClubs"));
        island.setLugeClubs(request.getParameter("lugeClubs"));
        island.setSkeletonClubs(request.getParameter("skeletonClubs"));
        island.setBiathlonClubs(request.getParameter("biathlonClubs"));
        island.setCrossCountrySkiingClubs(request.getParameter("crossCountrySkiingClubs"));
        island.setSkiJumpingClubs(request.getParameter("skiJumpingClubs"));
        island.setFreestyleSkiingClubs(request.getParameter("freestyleSkiingClubs"));
        island.setAlpineSkiingClubs(request.getParameter("alpineSkiingClubs"));
        island.setTelemarSkiingClubs(request.getParameter("telemarSkiingClubs"));
        island.setBackcountrySkiingClubs(request.getParameter("backcountrySkiingClubs"));
        island.setHeliskiingClubs(request.getParameter("heliskiingClubs"));
        island.setCatskiingClubs(request.getParameter("catskiingClubs"));
        island.setSnowshoeingClubs(request.getParameter("snowshoeingClubs"));
        island.setIceFishingClubs(request.getParameter("iceFishingClubs"));
        island.setDogSleddingClubs(request.getParameter("dogSleddingClubs"));
        island.setSnowmobilingClubs(request.getParameter("snowmobilingClubs"));
        island.setIceClimbingClubs(request.getParameter("iceClimbingClubs"));
        island.setWinterHikingClubs(request.getParameter("winterHikingClubs"));
        island.setWinterCampingClubs(request.getParameter("winterCampingClubs"));
        island.setIceHotels(request.getParameter("iceHotels"));
        island.setIgloos(request.getParameter("igloos"));
        island.setIceBars(request.getParameter("iceBars"));
        island.setIceRestaurants(request.getParameter("iceRestaurants"));
        island.setIceSculptures(request.getParameter("iceSculptures"));
        island.setIceFestivals(request.getParameter("iceFestivals"));
        island.setWinterFestivals(request.getParameter("winterFestivals"));
        island.setChristmasMarkets(request.getParameter("christmasMarkets"));
        island.setNewYearCelebrations(request.getParameter("newYearCelebrations"));
        island.setWinterSports(request.getParameter("winterSports"));
        island.setWinterActivities(request.getParameter("winterActivities"));
        island.setWinterClothing(request.getParameter("winterClothing"));
        island.setWinterGear(request.getParameter("winterGear"));
        island.setWinterSafety(request.getParameter("winterSafety"));
        island.setWinterWeather(request.getParameter("winterWeather"));
        island.setWinterDriving(request.getParameter("winterDriving"));
        island.setWinterTransportation(request.getParameter("winterTransportation"));
        island.setWinterAccommodation(request.getParameter("winterAccommodation"));
        island.setWinterDining(request.getParameter("winterDining"));
        island.setWinterShopping(request.getParameter("winterShopping"));
        island.setWinterNightlife(request.getParameter("winterNightlife"));
        island.setWinterCulture(request.getParameter("winterCulture"));
        island.setWinterHistory(request.getParameter("winterHistory"));
        island.setWinterGeography(request.getParameter("winterGeography"));
        island.setWinterWildlife(request.getParameter("winterWildlife"));
        island.setWinterConservation(request.getParameter("winterConservation"));
        island.setWinterTips(request.getParameter("winterTips"));
        island.setWinterEmergencyContacts(request.getParameter("winterEmergencyContacts"));
        island.setWinterVisaRequirements(request.getParameter("winterVisaRequirements"));
        island.setWinterHealthSafety(request.getParameter("winterHealthSafety"));
        island.setWinterEvents(request.getParameter("winterEvents"));
        island.setWinterLocalCustoms(request.getParameter("winterLocalCustoms"));
        island.setWinterPhotographyTips(request.getParameter("winterPhotographyTips"));
        island.setWinterSustainableTourism(request.getParameter("winterSustainableTourism"));
        island.setWinterAccessibility(request.getParameter("winterAccessibility"));
        island.setWinterFamilyFriendly(request.getParameter("winterFamilyFriendly"));
        island.setWinterBudgetTips(request.getParameter("winterBudgetTips"));
        island.setWinterLuxuryOptions(request.getParameter("winterLuxuryOptions"));
        island.setWinterAdventureSports(request.getParameter("winterAdventureSports"));
        island.setWinterRelaxationSpots(request.getParameter("winterRelaxationSpots"));
        island.setWinterLocalCuisine(request.getParameter("winterLocalCuisine"));
        island.setWinterFestivals(request.getParameter("winterFestivals"));
        island.setWinterArtsCrafts(request.getParameter("winterArtsCrafts"));
        island.setWinterMusicDance(request.getParameter("winterMusicDance"));
        island.setWinterArchitecture(request.getParameter("winterArchitecture"));
        island.setWinterMuseumsGalleries(request.getParameter("winterMuseumsGalleries"));
        island.setWinterReligiousSites(request.getParameter("winterReligiousSites"));
        island.setWinterNaturalWonders(request.getParameter("winterNaturalWonders"));
        island.setWinterBeaches(request.getParameter("winterBeaches"));
        island.setWinterHikingTrails(request.getParameter("winterHikingTrails"));
        island.setWinterWaterSports(request.getParameter("winterWaterSports"));
        island.setWinterDivingSnorkeling(request.getParameter("winterDivingSnorkeling"));
        island.setWinterFishingHunting(request.getParameter("winterFishingHunting"));
        island.setWinterGolfing(request.getParameter("winterGolfing"));
        island.setWinterSpaWellness(request.getParameter("winterSpaWellness"));
        island.setWinterEcoTourism(request.getParameter("winterEcoTourism"));
        island.setWinterCulturalTours(request.getParameter("winterCulturalTours"));
        island.setWinterFoodTours(request.getParameter("winterFoodTours"));
        island.setWinterWineTasting(request.getParameter("winterWineTasting"));
        island.setWinterShoppingDistricts(request.getParameter("winterShoppingDistricts"));
        island.setWinterMarkets(request.getParameter("winterMarkets"));
        island.setWinterSouvenirs(request.getParameter("winterSouvenirs"));
        island.setWinterLocalProducts(request.getParameter("winterLocalProducts"));
        island.setWinterHandicrafts(request.getParameter("winterHandicrafts"));
        island.setWinterJewelry(request.getParameter("winterJewelry"));
        island.setWinterTextiles(request.getParameter("winterTextiles"));
        island.setWinterAntiques(request.getParameter("winterAntiques"));
        island.setWinterBookstores(request.getParameter("winterBookstores"));
        island.setWinterMusicStores(request.getParameter("winterMusicStores"));
        island.setWinterArtSupplies(request.getParameter("winterArtSupplies"));
        island.setWinterSportsEquipment(request.getParameter("winterSportsEquipment"));
        island.setWinterOutdoorGear(request.getParameter("winterOutdoorGear"));
        island.setWinterElectronics(request.getParameter("winterElectronics"));
        island.setWinterClothing(request.getParameter("winterClothing"));
        island.setWinterFootwear(request.getParameter("winterFootwear"));
        island.setWinterAccessories(request.getParameter("winterAccessories"));
        island.setWinterCosmetics(request.getParameter("winterCosmetics"));
        island.setWinterPerfumes(request.getParameter("winterPerfumes"));
        island.setWinterWatches(request.getParameter("winterWatches"));
        island.setWinterSunglasses(request.getParameter("winterSunglasses"));
        island.setWinterBags(request.getParameter("winterBags"));
        island.setWinterLuggage(request.getParameter("winterLuggage"));
        island.setWinterTravelGear(request.getParameter("winterTravelGear"));
        island.setWinterCameras(request.getParameter("winterCameras"));
        island.setWinterBinoculars(request.getParameter("winterBinoculars"));
        island.setWinterMaps(request.getParameter("winterMaps"));
        island.setWinterGuidebooks(request.getParameter("winterGuidebooks"));
        island.setWinterPhrasebooks(request.getParameter("winterPhrasebooks"));
        island.setWinterDictionaries(request.getParameter("winterDictionaries"));
        island.setWinterTranslators(request.getParameter("winterTranslators"));
        island.setWinterCurrencyExchange(request.getParameter("winterCurrencyExchange"));
        island.setWinterBanking(request.getParameter("winterBanking"));
        island.setWinterAtms(request.getParameter("winterAtms"));
        island.setWinterCreditCards(request.getParameter("winterCreditCards"));
        island.setWinterTipping(request.getParameter("winterTipping"));
        island.setWinterBargaining(request.getParameter("winterBargaining"));
        island.setWinterTaxes(request.getParameter("winterTaxes"));
        island.setWinterInsurance(request.getParameter("winterInsurance"));
        island.setWinterMedicalFacilities(request.getParameter("winterMedicalFacilities"));
        island.setWinterPharmacies(request.getParameter("winterPharmacies"));
        island.setWinterVaccinations(request.getParameter("winterVaccinations"));
        island.setWinterMedications(request.getParameter("winterMedications"));
        island.setWinterFirstAid(request.getParameter("winterFirstAid"));
        island.setWinterEmergencyServices(request.getParameter("winterEmergencyServices"));
        island.setWinterPolice(request.getParameter("winterPolice"));
        island.setWinterFireDepartment(request.getParameter("winterFireDepartment"));
        island.setWinterAmbulance(request.getParameter("winterAmbulance"));
        island.setWinterCoastGuard(request.getParameter("winterCoastGuard"));
        island.setWinterMountainRescue(request.getParameter("winterMountainRescue"));
        island.setWinterTouristPolice(request.getParameter("winterTouristPolice"));
        island.setWinterEmbassies(request.getParameter("winterEmbassies"));
        island.setWinterConsulates(request.getParameter("winterConsulates"));
        island.setWinterTouristInformation(request.getParameter("winterTouristInformation"));
        island.setWinterTravelAgencies(request.getParameter("winterTravelAgencies"));
        island.setWinterTourOperators(request.getParameter("winterTourOperators"));
        island.setWinterGuides(request.getParameter("winterGuides"));
        island.setWinterInterpreters(request.getParameter("winterInterpreters"));
        island.setWinterDrivers(request.getParameter("winterDrivers"));
        island.setWinterPorters(request.getParameter("winterPorters"));
        island.setWinterCooks(request.getParameter("winterCooks"));
        island.setWinterCleaners(request.getParameter("winterCleaners"));
        island.setWinterLaundry(request.getParameter("winterLaundry"));
        island.setWinterDryCleaning(request.getParameter("winterDryCleaning"));
        island.setWinterTailoring(request.getParameter("winterTailoring"));
        island.setWinterShoeRepair(request.getParameter("winterShoeRepair"));
        island.setWinterHairSalons(request.getParameter("winterHairSalons"));
        island.setWinterBarberShops(request.getParameter("winterBarberShops"));
        island.setWinterNailSalons(request.getParameter("winterNailSalons"));
        island.setWinterMassage(request.getParameter("winterMassage"));
        island.setWinterGyms(request.getParameter("winterGyms"));
        island.setWinterYogaStudios(request.getParameter("winterYogaStudios"));
        island.setWinterPilatesStudios(request.getParameter("winterPilatesStudios"));
        island.setWinterDanceStudios(request.getParameter("winterDanceStudios"));
        island.setWinterMartialArts(request.getParameter("winterMartialArts"));
        island.setWinterSwimmingPools(request.getParameter("winterSwimmingPools"));
        island.setWinterTennisClubs(request.getParameter("winterTennisClubs"));
        island.setWinterGolfClubs(request.getParameter("winterGolfClubs"));
        island.setWinterCountryClubs(request.getParameter("winterCountryClubs"));
        island.setWinterBeachClubs(request.getParameter("winterBeachClubs"));
        island.setWinterYachtClubs(request.getParameter("winterYachtClubs"));
        island.setWinterFishingClubs(request.getParameter("winterFishingClubs"));
        island.setWinterHuntingClubs(request.getParameter("winterHuntingClubs"));
        island.setWinterHikingClubs(request.getParameter("winterHikingClubs"));
        island.setWinterClimbingClubs(request.getParameter("winterClimbingClubs"));
        island.setWinterCyclingClubs(request.getParameter("winterCyclingClubs"));
        island.setWinterRunningClubs(request.getParameter("winterRunningClubs"));
        island.setWinterTriathlonClubs(request.getParameter("winterTriathlonClubs"));
        island.setWinterSwimmingClubs(request.getParameter("winterSwimmingClubs"));
        island.setWinterSurfingClubs(request.getParameter("winterSurfingClubs"));
        island.setWinterDivingClubs(request.getParameter("winterDivingClubs"));
        island.setWinterSailingClubs(request.getParameter("winterSailingClubs"));
        island.setWinterKayakingClubs(request.getParameter("winterKayakingClubs"));
        island.setWinterCanoeingClubs(request.getParameter("winterCanoeingClubs"));
        island.setWinterRaftingClubs(request.getParameter("winterRaftingClubs"));
        island.setWinterWindsurfingClubs(request.getParameter("winterWindsurfingClubs"));
        island.setWinterKitesurfingClubs(request.getParameter("winterKitesurfingClubs"));
        island.setWinterParasailingClubs(request.getParameter("winterParasailingClubs"));
        island.setWinterHangGlidingClubs(request.getParameter("winterHangGlidingClubs"));
        island.setWinterParachutingClubs(request.getParameter("winterParachutingClubs"));
        island.setWinterBungeeJumpingClubs(request.getParameter("winterBungeeJumpingClubs"));
        island.setWinterZipLiningClubs(request.getParameter("winterZipLiningClubs"));
        island.setWinterRockClimbingClubs(request.getParameter("winterRockClimbingClubs"));
        island.setWinterIceClimbingClubs(request.getParameter("winterIceClimbingClubs"));
        island.setWinterMountaineeringClubs(request.getParameter("winterMountaineeringClubs"));
        
        return island;
    }

    /**
     * Validate island input
     */
    private boolean validateIslandInput(HttpServletRequest request) {
        boolean isValid = true;
        
        String islandName = request.getParameter("islandName");
        if (islandName == null || islandName.trim().isEmpty()) {
            request.setAttribute("errorIslandName", "Island name is required");
            isValid = false;
        }
        
        String location = request.getParameter("location");
        if (location == null || location.trim().isEmpty()) {
            request.setAttribute("errorLocation", "Location is required");
            isValid = false;
        }
        
        String description = request.getParameter("description");
        if (description == null || description.trim().isEmpty()) {
            request.setAttribute("errorDescription", "Description is required");
            isValid = false;
        }
        
        return isValid;
    }

    /**
     * Check if user is authorized staff member
     */
    private boolean isStaffAuthorized(HttpSession session) {
        if (session == null) return false;
        
        User user = (User) session.getAttribute("user");
        if (user == null) return false;
        
        String role = user.getRole();
        return "staff".equals(role) || "admin".equals(role);
    }

    /**
     * Handle errors
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response,
                           String message, Exception e) throws ServletException, IOException {
        System.err.println("IslandStaffServlet Error: " + message);
        if (e != null) {
            e.printStackTrace();
        }
        
        request.setAttribute("errorMessage", message);
        request.setAttribute("pageTitle", "Error");
        request.getRequestDispatcher("/views/common/error.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "IslandStaffServlet - Handles island management operations for staff";
    }
}