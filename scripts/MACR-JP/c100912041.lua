--LL－インディペンデント・ナイチンゲール
--Lyrical Luscinia - Independent Nightingale
--Scripted by Eerie Code
--Effect is not fully implemented
function c100912041.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,100912043,aux.FilterBoolFunction(Card.IsFusionSetCard,0x1f8),1,true,true)
	--increase level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100912041,0))
	e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c100912041.lvcon)
	e1:SetOperation(c100912041.lvop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c100912041.efilter)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c100912041.atkval)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100912041,1))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1)
	e4:SetTarget(c100912041.damtg)
	e4:SetOperation(c100912041.damop)
	c:RegisterEffect(e4)
	--checks previous ORU on field (similar to Cipher Spectrum)
	if not c100912041.global_check then
		c100912041.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD_P)
		ge1:SetOperation(c100912041.checkop)
		Duel.RegisterEffect(ge1,tp)
	end
end
function c100912041.checkfilter(c,tp)
	return c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0
end
function c100912041.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not eg then return  end
	local sg=eg:Filter(c100912041.checkfilter,nil,tp)
	local tc=sg:GetFirst()
	while tc do
		local oc=tc:GetOverlayCount()
		if oc>0 then
			for i=1,oc do
				tc:RegisterFlagEffect(100912041,RESET_EVENT+0x1fe0000-EVENT_TO_GRAVE,0,1)
			end
		end
		tc=sg:GetNext()
	end
end
function c100912041.lvfilter(c)
	return c:IsSetCard(0x1f8) and c:GetFlagEffect(100912041)>0
end
function c100912041.lvcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and mg and mg:IsExists(c100912041.lvfilter,1,nil)
end
function c100912041.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local mg=c:GetMaterial():Filter(c100912041.lvfilter,nil)
	local lv=0
	local mc=mg:GetFirst()
	while mc do
		lv=lv+mc:GetFlagEffect(100912041)
		mc=mg:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(lv)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
end
function c100912041.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c100912041.atkval(e,c)
	return c:GetLevel()*500
end
function c100912041.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetHandler():GetLevel()*500)
end
function c100912041.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local lv=e:GetHandler():GetLevel()
	Duel.Damage(p,lv*500,REASON_EFFECT)
end
