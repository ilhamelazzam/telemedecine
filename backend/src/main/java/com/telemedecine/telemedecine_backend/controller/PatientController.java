package com.telemedecine.telemedecine_backend.controller;

import com.telemedecine.telemedecine_backend.model.Patient;
import com.telemedecine.telemedecine_backend.repository.PatientRepository;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/patients")
@CrossOrigin(origins = "http://localhost:3000") // pour ton futur React
public class PatientController {

    private final PatientRepository patientRepository;

    public PatientController(PatientRepository patientRepository) {
        this.patientRepository = patientRepository;
    }

    // GET /api/patients
    @GetMapping
    public List<Patient> getAll() {
        return patientRepository.findAll();
    }

    // POST /api/patients
    @PostMapping
    public Patient create(@RequestBody Patient patient) {
        return patientRepository.save(patient);
    }

    // GET /api/patients/{id}
    @GetMapping("/{id}")
    public Patient getById(@PathVariable Long id) {
        return patientRepository.findById(id).orElse(null);
    }

    // DELETE /api/patients/{id}
    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        patientRepository.deleteById(id);
    }
}
