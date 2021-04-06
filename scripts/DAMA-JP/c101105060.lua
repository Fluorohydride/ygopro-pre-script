--機巧伝－神使記紀図
--
--Script by XyleN5967
function c101105060.initial_effect(c)
	c:EnableCounterPermit(0x161,LOCATION_FZONE)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101105060,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,101105060)
	e2:SetTarget(c101105060.thtg)
	e2:SetOperation(c101105060.thop)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c101105060.countercon)
	e3:SetOperation(c101105060.counterop)
	c:RegisterEffect(e3)
	local e4=e3:Clone() 
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--act limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_TRIGGER)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetCondition(c101105060.actlimitcon)
	e5:SetTarget(c101105060.actlimittg)
	c:RegisterEffect(e5)
end
if Auxiliary.AtkEqualsDef==nil then
	function Auxiliary.AtkEqualsDef(c)
		if not c:IsType(TYPE_MONSTER) or c:IsType(TYPE_LINK) then return false end
		if c:GetAttack()~=c:GetDefense() then return false end
		return c:IsLocation(LOCATION_MZONE) or c:GetTextAttack()>=0 and c:GetTextDefense()>=0
	end
end
function c101105060.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c101105060.thfilter(c)
	return aux.AtkEqualsDef(c) and c:IsRace(RACE_MACHINE) and c:IsAbleToHand()
end
function c101105060.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(c101105060.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(101105060,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c101105060.thfilter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT+REASON_REVEAL)
	end
end
function c101105060.cfilter(c)
	return aux.AtkEqualsDef(c) and c:IsRace(RACE_MACHINE) and c:IsFaceup()
end
function c101105060.countercon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101105060.cfilter,1,nil)
end
function c101105060.counterop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x161,1)
end
function c101105060.actlimitcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x161)>=10
end
function c101105060.actlimittg(e,c)
	return c:GetAttack()~=c:GetDefense()
end
