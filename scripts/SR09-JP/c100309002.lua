--昇華騎士－エクスパラディン

--Scripted by mallu11
function c100309002.initial_effect(c)
        --equid
        local e1=Effect.CreateEffect(c)
        e1:SetCategory(CATEGORY_EQUIP)
        e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
        e1:SetCode(EVENT_SUMMON_SUCCESS)
        e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
        e1:SetCountLimit(1,100309002)
        e1:SetTarget(c100309002.eqtg)
        e1:SetOperation(c100309002.eqop)
        c:RegisterEffect(e1)
        local e2=Effect.Clone(e1)
        e2:SetCode(EVENT_SPSUMMON_SUCCESS)
        c:RegisterEffect(e2)
        --spsummon
        local e3=Effect.CreateEffect(c)
        e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
        e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
        e3:SetCode(EVENT_DESTROYED)
        e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
        e3:SetCountLimit(1,100309102)
        e3:SetCondition(c100309002.spcon)
        e3:SetTarget(c100309002.sptg)
        e3:SetOperation(c100309002.spop)
        c:RegisterEffect(e3)
end
function c100309002.eqfilter(c)
        return c:IsType(TYPE_DUAL) or (c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE))
end
function c100309002.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
        if chk==0 then 
            return Duel.IsExistingMatchingCard(c100309002.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) 
            and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
        Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function c100309002.eqop(e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
        if c:IsRelateToEffect(e) and c:IsControler(tp) and c:IsFaceup() 
            and c:IsLocation(LOCATION_MZONE) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
            local g=Duel.SelectMatchingCard(tp,c100309002.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
            local tc=g:GetFirst()
            if not Duel.Equip(tp,tc,c) then return end
            --equip limit
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
            e1:SetCode(EFFECT_EQUIP_LIMIT)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            e1:SetLabelObject(c)
            e1:SetValue(c100309002.eqlimit)
            tc:RegisterEffect(e1)
            --atk up
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_EQUIP)
            e2:SetCode(EFFECT_UPDATE_ATTACK)
            e2:SetValue(500)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e2)
        end
end
function c100309002.eqlimit(e,c)
        return c==e:GetLabelObject()
end
function c100309002.spfilter1(c,e,tp)
        return c:IsType(TYPE_DUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100309002.spfilter2(c,e,tp)
        return c:IsType(TYPE_DUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetPreviousEquipTarget()==e:GetHandler()
end
function c100309002.spcon(e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        local g=c:GetEquipGroup()
        local sg=g:Filter(c100309002.spfilter1,nil,e,tp)
        return sg:GetCount() and rp==1-tp
end
function c100309002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
        if chk==0 then 
            return Duel.IsExistingMatchingCard(c100309002.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,nil,0,0)
end
function c100309002.spop(e,tp,eg,ep,ev,re,r,rp)
        local mc=Duel.GetLocationCount(tp,LOCATION_MZONE)
        local ft=mc
        if mc<=0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.GetMatchingGroup(c100309002.spfilter2,tp,LOCATION_GRAVE,0,nil,e,tp)
        if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
        local sg=g:Select(tp,ft,ft,nil)
        local count=0
        if sg:GetCount()>0 then
            local tc=sg:GetFirst()
            while tc do
                Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
                tc:EnableDualState()
                tc=sg:GetNext()
                count=count+1
            end
        end
        if count>0 then
            Duel.SpecialSummonComplete()
        end
end

