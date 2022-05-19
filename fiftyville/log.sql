-- Keep a log of any SQL queries you execute as you solve the mystery.

-- What we know: 
-- theft took place on july 28, 2021
-- theft took place on Humphrey Street

-- First, we find the police reports from crime_scene_reports using day, month, year and street name:
SELECT description FROM crime_scene_reports WHERE day = 28 AND month = 7 AND year = 2021 AND street = "Humphrey Street";
-- Theft of the CS50 duck took place at 10:15am at the Humphrey Street bakery. Interviews were conducted today with three witnesses who were present at the time – each of their interview transcripts mentions the bakery.
-- NEW CLUES:
-- time of crime: 10:15am
-- business name: Humphrey Street Bakery
-- 3 interviews conducted 

-- Second, we find the interview transcripts searching thru day, month, year and that have word bakery somewhere in transcript
SELECT transcript FROM interviews WHERE day = 28 AND month = 7 AND year = 2021 AND transcript LIKE "%bakery%";
-- Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery parking lot and drive away. If you have security footage from the bakery parking lot, you might want to look for cars that left the parking lot in that time frame.
-- I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at Emma's bakery, I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.
-- As the thief was leaving the bakery, they called someone who talked to them for less than a minute. In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow. The thief then asked the person on the other end of the phone to purchase the flight ticket.
-- NEW CLUES:
-- Timeframe that shows thief leaving is 10:15 to 10:25
-- Thief made ATM withdrawal on Leggett Street earlier that day before 10:15
-- Thief called someone between 10:15 and 10:25 for less than 1 minute
-- Thief plans to take earliest flight out of Fiftyville on July 29th, 2021
-- Accomplice purchased ticket

-- Third, we use timeframe that shows thief leaving is 10:15 to 10:25 to see who owns cars leaving
SELECT name FROM people WHERE license_plate IN (SELECT license_plate FROM bakery_security_logs WHERE hour = 10 AND minute >= 15 AND minute <= 25 AND day = 28 AND month = 7 AND year = 2021);
-- Suspects: Vanessa, Barry, Iman, Sofia, Luca, Diana, Kelsey, Bruce

-- Next, we check who made ATM withdrawal on Leggett Street earlier that day before 10:15.
-- We get to account_number from atm_transactions to get to person_id in bank_accounts to get to name from people
SELECT name FROM people WHERE id IN (SELECT person_id FROM bank_accounts WHERE account_number IN (SELECT account_number FROM atm_transactions WHERE transaction_type = "withdraw" AND day = 28 AND month = 7 AND year = 2021 AND atm_location LIKE "%Leggett%"));
-- Suspects: Kenny, Iman, Benista, Taylor, Brooke, Luca, Diana, Bruce
-- Common results: Bruce, Iman, Luca, Diana

-- Next, we check for people who called someone for less than 1 minute
SELECT name FROM people WHERE phone_number IN (SELECT caller FROM phone_calls WHERE duration < 60 AND day = 28 AND month = 7 AND year = 2021);
-- Suspects: Kenny, Sofia, Benista, Taylor, Diana, Kelsey, Bruce, Carina
-- Common results: Bruce, Diana

-- Next, we check for passengers to take earliest flight out of Fiftyville on July 29th, 2021
SELECT name FROM people WHERE passport_number IN (SELECT passport_number FROM passengers WHERE flight_id IN (SELECT id FROM flights WHERE origin_airport_id IN (SELECT id FROM airports WHERE city LIKE "%Fiftyville%") AND day = 29 AND month = 7 AND year = 2021 ORDER BY hour, minute ASC LIMIT 1));
-- Suspects: Kenny, Sofia, Taylor, Luca, Kelsey, Edward, Bruce, Doris
-- THIEF: BRUCE

-- Next, we check what city Bruce escaped to
SELECT city FROM airports WHERE id IN (SELECT destination_airport_id FROM flights WHERE origin_airport_id IN (SELECT id FROM airports WHERE city LIKE "%Fiftyville%") AND day = 29 AND month = 7 AND year = 2021 ORDER BY hour, minute ASC LIMIT 1);
-- RESULT: New York City

-- Next, we check who Bruce called between 10:15 and 10:25
SELECT name FROM people WHERE phone_number IN (SELECT receiver FROM phone_calls WHERE caller IN (SELECT phone_number FROM people WHERE name = "Bruce") AND day = 28 AND month = 7 AND year = 2021 AND duration < 60);
-- ACCOMPLICE: Robin