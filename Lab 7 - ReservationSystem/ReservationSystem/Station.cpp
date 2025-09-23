///////////////////////////////////////////////////////////////////////////////////
// file:  Station.cpp
// Job:   holds the Station definitions 
//////////////////////////////////////////////////////////////////////////////////

#include "Station.h"
#include "Pump.h"
#include <thread>

using namespace std;

Station::Station(void) : freeMask(0)
{
	pumps = nullptr;
	pumpsInStation = 0;
}

Station::~Station(void)
{
	delete []pumps;
}

int Station::fillUp()
{
	/////////////////////////////////////////////////////////////////////////////////////////////
	// TODO:: Find a free pump and fill up using that pump, otherwise wait until a pump becomes
	//   available.
	//
	// 1) You will be using a single mutex and a 32-bit value to utilize up to 32 different pumps.
	//      Each bit in the 32-bit 'freemask' will represent the status of a single pump - in use
	//      or not in use. Refer to the documentation if you need a refresher on how to set, check
	//      and clear individual bits.
	//
	// 2) All accesses to shared memory must be thread safe and no two cars should even attempt to
	//      access the same pump at the same time.
	//
	// 3) You will be using the 'fillTankUp' method of the 'Pump' class to simulate a car filling
	//      up. Filling up must be implemented in such a way that allows for other cars to
	//      concurrently use the other pumps while a car fills up.
	//
	// 4) If a car fails to find an available pump it must wait until one becomes available.
	//
	// 5) After a car successfully fills up it must wait until enough time has gone by for 
	//		all other cars to fill up once. To do this, you'll need to look into the function sleep_for,
	//      which is found in the std::this_thread namespace. You will need to sleep for a value
	//      based on the information available to you (number of cars, number of pumps, how long
	//      a single car takes to fill up).
	//
	// NOTE: You may NOT modify any of the code outside of the TODOs or add any global or static
	//   variables UNLESS it's required by your algorithm for #5 above.
	/////////////////////////////////////////////////////////////////////////////////////////////

	while (true)
	{
			stationMutex->lock();
		for (int i = 0; i < pumpsInStation; i++)
		{
			if ((freeMask & (1 << i)) == 0) // is pump free
			{
				freeMask |= (1 << i); // in use
				stationMutex->unlock();

				pumps[i].fillTankUp();

				stationMutex->lock();
				freeMask &= ~(1 << i); // free
				stationMutex->unlock();

				// 5) number of cars, number of pumps, how long a single car takes to fill up
				if (carsInStation > 1 ) // exicute if more than 1 car
				{
					// -1 for this
					int carsFilling = (((carsInStation-1) + (pumpsInStation - 1)) / pumpsInStation);
					std::this_thread::sleep_for(std::chrono::milliseconds(carsFilling * 30)); // 30ms pump.cpp
				}
				
				return 1;
			}
			// milsec of not checking ?? durring incrementing
			//stationMutex->unlock(); // very slow
		}
		stationMutex->unlock(); // ERRORS

		// No pumps found, wait for tbd before trying again
		// lower to 5 is resulting in longer app time till complete
		std::this_thread::sleep_for(std::chrono::milliseconds(5)); // 30ms pump.cpp
	}

	// will never reach
	return 0;
}

int Station::getPumpFillCount(int num)
{
	if((num >= 0) && (num < pumpsInStation))
	{
		return pumps[num].getFillCount();
	}
	else 
	{
		return -1;
	}
}

void Station::createPumps(int numOfPumps)
{
	pumps = new Pump[numOfPumps];
	pumpsInStation = numOfPumps;
}

int Station::getCarsInStation(void)
{
	return this->carsInStation;
}

void Station::setCarsInStation(int num)
{
	this->carsInStation = num;
}

std::mutex* Station::getstationMutex(void)
{
	return this->stationMutex;
}

std::condition_variable* Station::getStationCondition(void)
{
	return this->stationCondition;
}

void Station::setStationMutex(std::mutex* m)
{
	this->stationMutex = m;
}

void Station::setStationCondition(std::condition_variable* cv)
{
	this->stationCondition = cv;
}
