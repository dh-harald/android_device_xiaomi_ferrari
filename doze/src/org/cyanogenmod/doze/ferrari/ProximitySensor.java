/*
 * Copyright (c) 2015 The CyanogenMod Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.cyanogenmod.doze.ferrari;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.os.SystemClock;
import android.util.Log;

public class ProximitySensor extends FerrariSensor {

    private static final boolean DEBUG = false;
    private static final String TAG = "ProximitySensor";
    private long mEntryTimestamp;
    private static final int DELTA_MS = 250;  // 250ms

    public ProximitySensor(Context context) {
        super(context, Sensor.TYPE_PROXIMITY);
    }

    @Override
    public void enable() {
        if (DEBUG) Log.d(TAG, "Enabling");
        super.enable();
        mEntryTimestamp = 0;
    }

    @Override
    public void disable() {
        if (DEBUG) Log.d(TAG, "Disabling");
        super.disable();
    }

    @Override
    protected void onSensorEvent(SensorEvent event) {
        if (DEBUG) Log.d(TAG, "Got sensor event: " + event.values[0]);

        long delta = SystemClock.elapsedRealtime() - mEntryTimestamp;
        boolean isNear = event.values[0] == 0;

        if ( !isNear && delta < DELTA_MS )
        {
            launchDozePulse();
        }
        mEntryTimestamp = SystemClock.elapsedRealtime();
    }
}
